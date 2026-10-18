from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

def get_ChatOpenAI():
    load_dotenv()

    return ChatOpenAI(
        model="gpt-5-nano",
        reasoning_effort="high",        # 논리성 강화
    )


def create_llm_with_tools(available_tools:list):
    """도구가 연결된 LLM 생성"""
    llm = get_ChatOpenAI()
    return llm.bind_tools(available_tools) # LLM에 등록된 tools 적용

