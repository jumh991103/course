from typing import Annotated, Sequence, TypedDict
from langgraph.graph.message import add_messages
from langchain_core.messages import BaseMessage

# 에이전트 상태 정의
class AgentState(TypedDict):
    """
    ReAct 에이전트의 상태를 정의합니다.
    """
    # add_messages는 리듀서(reducer) 함수입니다
    # 이는 새로운 메시지들을 기존 메시지 리스트에 자동으로 추가해줍니다
    messages: Annotated[Sequence[BaseMessage], add_messages]

