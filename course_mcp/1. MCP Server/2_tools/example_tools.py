from fastmcp import FastMCP
from fastmcp.server.dependencies import get_context

mcp = FastMCP("Course — Tools only")


@mcp.tool()
def add_integers(a: int, b: int) -> int:
    """두 정수를 더한다. 타입 힌트가 도구 입력 스키마로 노출된다."""
    return a + b

@mcp.resource("course://glossary/{term}")
def get_glossary_entry(term: str) -> str:
    """간단한 용어 설명(데모). 실제로는 DB·파일에서 조회할 수 있다."""
    entries = {
        "mcp": "Model Context Protocol — LLM 클라이언트와 외부 기능을 연결하는 표준.",
        "resource": "URI로 읽는 읽기 전용 데이터.",
        "tool": "스키마가 있는 실행 가능한 함수.",
    }
    key = term.strip().lower()
    return entries.get(key, f"'{term}' 항목은 아직 glossary에 없습니다.")

@mcp.tool()
async def lookup_glossary(term: str) -> str:
    """`course://glossary/{term}` 리소스를 읽어 용어 설명 문자열을 반환한다."""
    ctx = get_context()
    uri = f"course://glossary/{term.strip()}"
    result = await ctx.read_resource(uri)
    if not result.contents:
        return ""
    body = result.contents[0].content
    return body if isinstance(body, str) else body.decode("utf-8", errors="replace")


if __name__ == "__main__":
    mcp.run()
