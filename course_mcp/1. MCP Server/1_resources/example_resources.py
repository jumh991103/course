from __future__ import annotations

import json

from fastmcp import FastMCP

mcp = FastMCP("Course — Resources only")


@mcp.resource("course://syllabus")
def get_syllabus() -> str:
    """이 모듈에서 다루는 MCP 서버 구성 요소 요약."""
    return json.dumps({
        "modules": [
            {"name": "Resources", "role": "read-only data by URI"},
            {"name": "Tools", "role": "functions the LLM can invoke"},
            {"name": "Prompts", "role": "parameterized message templates"},
        ],
        "sdk": "FastMCP",
    }, ensure_ascii=False, indent=2)


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


if __name__ == "__main__":
    mcp.run()
