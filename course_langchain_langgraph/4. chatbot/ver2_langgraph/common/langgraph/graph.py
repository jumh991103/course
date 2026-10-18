from langgraph.graph import StateGraph, END, START 
import streamlit as st

from common.db.checkpointer import get_checkpointer
from .state import AgentState
from .nodes import call_model, tool_node

def __is_continue(sate: AgentState):
    """
    다음에 어떤 노드로 이동할지 결정하는 조건부 엣지 함수입니다.
    """
    messages = sate["messages"]
    last_message = messages[-1]

    # 마지막 메시지에 도구 호출이 있는지 확인
    if not last_message.tool_calls:
        return "end"
    else:
        return "continue"

@st.cache_resource
def create_graph(add_checkpointer:bool=True):
    workflow = StateGraph(AgentState)

    workflow.add_node("agent", call_model)
    workflow.add_node("tools", tool_node)

    # workflow.add_node(START, "agent")
    workflow.set_entry_point("agent")
    workflow.add_conditional_edges(
        # 시작 노드: agent 노드 실행 후 조건 확인
        "agent",
        # 조건 함수: __is_continue 함수로 다음 노드 결정
        __is_continue,
        # 조건에 따른 경로 매핑
        {
            "continue": "tools",  # 도구 호출이 있으면 tools 노드로
            "end": END,          # 도구 호출이 없으면 종료
        },
    )
    workflow.add_edge("tools", "agent")

    if add_checkpointer:
        return workflow.compile(checkpointer=get_checkpointer())
    else:
        return workflow.compile()
    