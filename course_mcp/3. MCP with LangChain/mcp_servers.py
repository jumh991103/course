import argparse
import asyncio
import os
import sys
import logging
from pathlib import Path
from typing import Literal

from dotenv import load_dotenv
from fastmcp import FastMCP

_ROOT = Path(__file__).resolve().parent
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from common.rag.elasticsearch_vector import ElasticsearchVectorStore
from common.mcp.constants import MCPConstants

load_dotenv(_ROOT / ".env")

mcp = FastMCP(
    "Course — RAG & Workspace",
    instructions=(
        "강의용 지식베이스(RAG)는 rag_vector_search로 검색한다. "
        "메모·노트·실습 파일은 workspace_list_files, workspace_read_text, workspace_write_text로 "
        "mcp_workspace 폴더 안에서만 다룬다."
    ),
)

def _workspace_root() -> Path:
    raw = os.environ.get("MCP_WORKSPACE_ROOT")
    if raw:
        return Path(raw).resolve()
    return (_ROOT / "mcp_workspace").resolve()


def _safe_workspace_path(relative_path: str) -> Path:
    rel = relative_path.strip().replace("\\", "/").lstrip("/")
    root = _workspace_root()
    target = (root / rel).resolve()
    try:
        target.relative_to(root)
    except ValueError as e:
        raise RuntimeError("경로가 workspace 루트 밖을 가리킵니다.") from e
    return target


@mcp.tool()
async def rag_vector_search(query: str, k: int = 4) -> str:
    """지식 용어집(RAG 인덱스)에서 의미 유사도 검색. 'OOO가 뭐야', '정의 알려줘' 등에 사용."""
    logging.info(f"rag_vector_search: {query}, {k}")

    q = query.strip()
    if not q:
        raise RuntimeError("query가 비어 있습니다.")
    k = max(1, min(int(k), 20))
    store = ElasticsearchVectorStore()
    store.k = k
    docs = store.similarity_search(q, k=k)
    if not docs:
        return "(검색 결과 없음)"
    lines = []
    for i, d in enumerate(docs, 1):
        meta = d.metadata or {}
        src = meta.get("source", "")
        lines.append(f"[{i}] (source={src})\n{d.page_content}")
    return "\n\n---\n\n".join(lines)


@mcp.tool()
async def workspace_list_files(relative_dir: str = "") -> str:
    """mcp_workspace 내 하위 디렉터리 목록과 파일 이름을 나열한다. relative_dir는 workspace 기준 상대 경로."""
    logging.info(f"workspace_list_files: {relative_dir}")

    base = _safe_workspace_path(relative_dir or ".")
    if not base.exists():
        return "(경로 없음)"
    if base.is_file():
        return base.name
    rows = sorted(base.iterdir(), key=lambda p: (not p.is_dir(), p.name.lower()))
    if not rows:
        return "(비어 있음)"
    return "\n".join(f"{'[dir] ' if p.is_dir() else ''}{p.name}" for p in rows)


@mcp.tool()
async def workspace_read_text(relative_path: str) -> str:
    """mcp_workspace 아래 텍스트 파일을 읽는다."""
    logging.info(f"workspace_read_text: {relative_path}")

    path = _safe_workspace_path(relative_path)
    if not path.is_file():
        raise RuntimeError("파일이 없거나 파일이 아닙니다.")
    data = path.read_bytes()
    if len(data) > MCPConstants.MAX_WS_READ.value:
        raise RuntimeError(f"파일이 너무 큽니다(최대 {MCPConstants.MAX_WS_READ.value}바이트).")
    return data.decode("utf-8", errors="replace")


@mcp.tool()
async def workspace_write_text(
    relative_path: str,
    content: str,
    mode: Literal["create", "overwrite"] = "create",
) -> str:
    """mcp_workspace 아래에 텍스트를 쓴다. create는 기존 파일이 있으면 실패."""
    logging.info(f"workspace_write_text: {relative_path}, {content}, {mode}")
    
    path = _safe_workspace_path(relative_path)
    raw = content.encode("utf-8")
    if len(raw) > MCPConstants.MAX_WS_WRITE.value:
        raise RuntimeError(f"내용이 너무 큽니다(최대 {MCPConstants.MAX_WS_WRITE.value}바이트).")
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and mode == "create":
        raise RuntimeError("파일이 이미 있어 create 모드로 쓸 수 없습니다.")
    path.write_bytes(raw)
    return f"저장 완료: {path.relative_to(_workspace_root())} ({len(raw)} bytes)"


def _http_bind() -> tuple[str, int]:
    host = os.environ.get("MCP_HTTP_HOST", "127.0.0.1")
    port = int(os.environ.get("MCP_HTTP_PORT", "8766"))
    return host, port


def main() -> None:
    parser = argparse.ArgumentParser(description="MCP 서버 실행")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--sse", action="store_true", help="SSE transport로 실행")
    group.add_argument("--streamable-http", action="store_true", help="Streamable HTTP transport로 실행")
    group.add_argument("--http", action="store_true", help="HTTP transport로 실행")
    args = parser.parse_args()

    if args.sse:
        transport = "sse"
    elif args.streamable_http:
        transport = "streamable-http"
    elif args.http:
        transport = "http"
    else:
        mcp.run()
        return

    host, port = _http_bind()
    path: str | None = None
    if transport == "sse":
        raw = os.environ.get("MCP_SSE_PATH", "").strip()
        path = raw or None
    else:
        raw = os.environ.get("MCP_STREAMABLE_HTTP_PATH", "").strip()
        path = raw or None

    asyncio.run(
        mcp.run_http_async(
            transport=transport,
            host=host,
            port=port,
            path=path,
        )
    )


if __name__ == "__main__":
    main()
