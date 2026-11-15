import os
import sys
from typing import Any
from urllib.parse import urljoin

from langchain_mcp_adapters.client import MultiServerMCPClient

class Singleton(type):
	_instances = {}

	def __call__(cls, *args, **kwargs):
		if cls not in cls._instances:
			cls._instances[cls] = super(Singleton, cls)\
				.__call__(*args, **kwargs)
		return cls._instances[cls]

class MCP_Client(metaclass=Singleton):

    def __init__(self, root:str, 
                        file_name:str="mcp_servers.py",
                        server_name:str="course_rag") -> None:
        self.mcp_server_file_path = root / file_name
        self.server_name = server_name
    
    def __base_url(self, ) -> str:
        host = os.environ.get("MCP_HTTP_HOST", "127.0.0.1").strip()
        port = os.environ.get("MCP_HTTP_PORT", "8766").strip()
        return f"http://{host}:{port}"

    def __connections_dict(self) -> dict[str, Any]:
        """
        MCP Server 접속 설정값 딕셔너리
        기본은 상시 구동형 SSE(URL). MCP_USE_STDIO=1 이면 stdio.
        """
        if not self.mcp_server_file_path.is_file():
            raise FileNotFoundError(f"MCP 서버 스크립트 없음: {self.mcp_server_file_path}")

        use_stdio = os.environ.get("MCP_USE_STDIO", "").lower() in ("1", "true", "yes")
        if use_stdio:
            return {
                self.server_name: {
                    "command": sys.executable,
                    "args": [str(self.mcp_server_file_path)],
                    "transport": "stdio",
                }
            }

        mode = os.environ.get("MCP_CLIENT_TRANSPORT", "sse").lower().strip()
        base = self.__base_url()

        if mode in ("streamable-http", "streamable_http", "http"):
            raw = os.environ.get("MCP_STREAMABLE_HTTP_URL", "").strip()
            if raw:
                url = raw
            else:
                path = (os.environ.get("MCP_STREAMABLE_HTTP_PATH") or "/mcp").strip() or "/mcp"
                if not path.startswith("/"):
                    path = "/" + path
                url = urljoin(base + "/", path.lstrip("/"))
            return {self.server_name: {"transport": "http", "url": url}}

        raw = os.environ.get("MCP_SSE_URL", "").strip()
        if raw:
            url = raw
        else:
            path = (os.environ.get("MCP_SSE_PATH") or "/sse").strip() or "/sse"
            if not path.startswith("/"):
                path = "/" + path
            url = urljoin(base + "/", path.lstrip("/"))
        return {self.server_name: {"transport": "sse", "url": url}}

    def get_client(self):
        """
        MCP Client 생성
        """
        return MultiServerMCPClient(self.__connections_dict())

    def get_connection_info(self):
        return self.__connections_dict()[self.server_name]



