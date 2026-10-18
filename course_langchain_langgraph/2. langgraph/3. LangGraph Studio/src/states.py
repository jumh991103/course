from langgraph.graph.message import add_messages
from typing import Annotated
from typing_extensions import TypedDict

# 도구 사용 상태 정의
class AssistantState(TypedDict):
    """AI 개인 비서의 상태"""
    messages: Annotated[list, add_messages]
    tools_used: list  # 사용된 도구들 기록

