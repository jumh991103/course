from langchain.agents import create_agent

from .model import get_model

def get_agent(tools:list):
    return create_agent(
        get_model(),
        tools,
        system_prompt="""너는 강의 보조 에이전트다.
- 수업 용어·개념 질문은 반드시 rag_vector_search로 근거를 찾은 뒤, 검색 결과를 바탕으로 답한다.
- 학생 메모·실습 파일·요약 저장은 workspace_* 도구만 사용한다(허용 루트: mcp_workspace).
- 검색 결과에 없는 내용은 추측하지 말고, 검색 쿼리를 바꿔 다시 시도하거나 솔직히 모른다고 말한다.""",
    )


