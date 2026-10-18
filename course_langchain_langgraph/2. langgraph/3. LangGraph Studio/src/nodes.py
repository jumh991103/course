from langchain_core.messages import SystemMessage
from langchain_core.messages import ToolMessage

from src.states import AssistantState
from src.models import create_llm_with_tools, get_ChatOpenAI
from src.tools import get_available_tools

def ai_agent_node(state: AssistantState):
    """
    사용자 요청을 분석하고 필요한 도구를 사용하는 AI 에이전트
    """
    available_tools = get_available_tools()
    llm_with_tools = create_llm_with_tools(available_tools)
    
    # 시스템 프롬프트로 역할 부여
    system_prompt = SystemMessage(content="""
    당신은 도움이 되는 AI 개인 비서입니다. 
    사용자의 요청을 분석하여 적절한 도구를 사용해 도와주세요.
    
    사용 가능한 도구들:
    - calculator: 수학 계산
    - get_weather: 날씨 조회
    - schedule_reminder: 알림 설정
    - search_knowledge: 지식 검색
    
    도구가 필요없는 일반적인 대화도 가능합니다.
    """)
    
    messages = [system_prompt] + state["messages"]
    
    print("AI 에이전트가 요청을 분석 중...")
    response = llm_with_tools.invoke(messages)
    
    # 도구 호출이 있는지 확인
    if response.tool_calls:
        print(f"{len(response.tool_calls)}개의 도구를 사용합니다:")
        for tool_call in response.tool_calls:
            print(f"   - {tool_call['name']}: {tool_call['args']}")
    else:
        print("일반 대화로 응답합니다.")
    
    return {"messages": [response]}

def tool_execution_node(state: AssistantState):
    """
    AI가 요청한 도구들을 실제로 실행하는 노드
    """
    last_message = state["messages"][-1]
    
    if not last_message.tool_calls:
        # 도구 호출이 없으면 아무것도 하지 않음
        return {"messages": []}
    
    tool_results = []
    tools_used = []
    
    # 각 도구 호출 실행
    for tool_call in last_message.tool_calls:
        tool_name = tool_call["name"]
        tool_args = tool_call["args"]
        
        print(f"{tool_name} 실행 중... (인자: {tool_args})")
        
        # 도구 실행
        tool_function = next(tool for tool in get_available_tools() if tool.name == tool_name)
        try:
            result = tool_function.invoke(tool_args)
            print(f"{tool_name} 실행 완료: {result}")
            
            # 도구 결과를 메시지로 저장
            tool_message = ToolMessage(
                content=result,
                tool_call_id=tool_call["id"]
            )
            tool_results.append(tool_message)
            tools_used.append(tool_name)
            
        except Exception as e:
            error_msg = f"{tool_name} 실행 오류: {str(e)}"
            print(error_msg)
            
            tool_message = ToolMessage(
                content=error_msg,
                tool_call_id=tool_call["id"]
            )
            tool_results.append(tool_message)
    
    return {
        "messages": tool_results,
        "tools_used": tools_used
    }

def final_response_node(state: AssistantState):
    """
    도구 실행 결과를 바탕으로 최종 응답을 생성하는 노드
    """
    llm = get_ChatOpenAI()
    
    system_prompt = SystemMessage(content="""
    도구 실행 결과를 바탕으로 사용자에게 친근하고 도움이 되는 최종 답변을 제공하세요.
    도구 결과를 자연스럽게 해석하여 전달하고, 추가 도움이 필요한지 물어보세요.
    """)
    
    messages = [system_prompt] + state["messages"]
    response = llm.invoke(messages)
    
    print("최종 응답 생성 완료!")
    
    return {"messages": [response]}



