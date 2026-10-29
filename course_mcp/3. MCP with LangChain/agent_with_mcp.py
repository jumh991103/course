import argparse
import asyncio
import logging
import time
from pathlib import Path

from dotenv import load_dotenv

from langchain_core.messages import HumanMessage
from langchain_mcp_adapters.tools import load_mcp_tools

from common.mcp.client import MCP_Client
from common.langchain.agent import get_agent

logging.basicConfig(level=logging.INFO)

_ROOT = Path(__file__).resolve().parent
load_dotenv(_ROOT / ".env")

async def run_once(question: str) -> str:
    """질문 한 번에 대해 MCP 도구를 쓸 수 있는 에이전트를 돌리고, 최종 답 문자열을 반환한다.

    기본은 SSE/HTTP URL로 이미 떠 있는 MCP 서버에 붙는다(상시 프로세스).
    stdio는 MCP_USE_STDIO=1 일 때만 사용한다.

    도구 목록과 도구 호출이 같은 세션을 쓰도록 session + load_mcp_tools(session)을 사용한다.
    """
    # 1. MCP Server 접속 설정값 딕셔너리
    mcp_client = MCP_Client(root=_ROOT)
    # 2. MCP Client 생성 
    client = mcp_client.get_client()
    conn_info = mcp_client.get_connection_info()
    transport = conn_info.get("transport", "?")
    endpoint = conn_info.get("url", "")

    t_session = time.perf_counter()
    # 3. MCP Client를 통한 MCP Server 호출 
    async with client.session(mcp_client.server_name) as session:
        t_tools = time.perf_counter()
        # 4. MCP Server의 tool 호출 
        tools = await load_mcp_tools(session, server_name=mcp_client.server_name)
        logging.info(
            "MCP 도구 목록 로드(%s, 동일 세션): %.3fs, 도구 %d개, endpoint=%s",
            transport,
            time.perf_counter() - t_tools,
            len(tools),
            endpoint,
        )
        logging.debug(
            "도구 목록: %s",
            [(t.name, (t.description or "")[:80]) for t in tools],
        )

        # 5. Agent with MCP Server tool 생성 
        agent = get_agent(tools)

        t_agent = time.perf_counter()
        result = await agent.ainvoke(
            {"messages": [HumanMessage(content=question)]},
            config={"recursion_limit": 40},
        )
        logging.info("에이전트 실행(ainvoke): %.3fs", time.perf_counter() - t_agent)

    logging.info(
        "MCP 세션 전체(연결~종료): %.3fs",
        time.perf_counter() - t_session,
    )
    messages = result.get("messages", [])
    if not messages:
        return ""
    return str(messages[-1].content)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="RAG 에이전트 실행",
        epilog=(
            "먼저 다른 터미널에서 MCP 서버를 띄운다:\n"
            "  python mcp_servers.py --sse\n"
            "  또는: python mcp_servers.py --streamable-http\n"
            "그다음 MCP_CLIENT_TRANSPORT(sse|streamable-http), MCP_HTTP_HOST, MCP_HTTP_PORT 등 .env 확인.\n"
            "stdio만 쓸 때: MCP_USE_STDIO=1"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("question", nargs="+", help='질문 텍스트 (예: 임베딩이 뭐야?)')
    args = parser.parse_args()
    question = " ".join(args.question).strip()

    logging.info(f"Question: {question}")
    answer = asyncio.run(run_once(question))
    logging.info(f"Answer: {answer}")

if __name__ == "__main__":
    main()
