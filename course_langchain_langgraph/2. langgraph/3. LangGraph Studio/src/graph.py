from langgraph.graph import StateGraph

from src.states import AssistantState
from src.nodes import ai_agent_node, tool_execution_node, final_response_node

def should_use_tools(state: AssistantState) -> str:
    """도구 사용이 필요한지 판단하는 라우팅 함수"""
    last_message = state["messages"][-1]
    
    if hasattr(last_message, 'tool_calls') and last_message.tool_calls:
        print("라우팅: 도구 실행 필요 → 도구 실행 노드로")
        return "execute_tools"
    else:
        print("라우팅: 도구 실행 불필요 → 최종 응답으로")
        return "final_response"


def create_ai_assistant():
    """도구를 사용하는 AI 개인 비서 그래프"""
    ##################################################
    # 그래프를 생성할 객체 생성   
    ##################################################
    workflow = StateGraph(AssistantState)
    
    ##################################################
    # 모든 노드 추가
    ##################################################
    workflow.add_node("ai_agent", ai_agent_node)
    workflow.add_node("execute_tools", tool_execution_node)
    workflow.add_node("final_response", final_response_node)
    
    ##################################################
    # 모든 엣지 추가 
    ##################################################
    # 시작점
    workflow.set_entry_point("ai_agent")
    
    # 조건부 엣지: AI 에이전트 → 도구 실행 or 최종 응답
    workflow.add_conditional_edges(
        "ai_agent",
        should_use_tools,
        {
            "execute_tools": "execute_tools",
            "final_response": "final_response"
        }
    )
    
    # 도구 실행 후에는 다시 AI 에이전트로 (결과 해석을 위해)
    workflow.add_edge("execute_tools", "final_response")
    
    # 최종 응답은 종료점
    workflow.set_finish_point("final_response")

    ##################################################
    # 컴파일 -> 그래프 생성  
    ##################################################  
    return workflow.compile()


# LangGraph Studio를 위한 graph 변수 export
graph = create_ai_assistant()


