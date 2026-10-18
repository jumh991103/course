from langchain_core.runnables import RunnableConfig
from langchain_core.messages import SystemMessage
import json
from langchain_core.messages import ToolMessage

from .state import AgentState
from .model import get_model
from .tools import search_weather, calculator, get_current_time

# AI 모델 호출 노드 정의
def call_model(state: AgentState, config: RunnableConfig):
    """
    AI 모델을 호출하여 응답을 생성하는 노드입니다.
    """

    # 시스템 프롬프트 설정
    system_prompt = SystemMessage(
        content="""당신은 도움이 되는 AI 어시스턴트입니다.
        사용자의 질문에 최선을 다해 답변해주세요!

        주어진 도구들을 적절히 활용하여 정확한 정보를 제공하세요.
        - 날씨 정보가 필요하면 get_weather 도구를 사용하세요
        - 계산이 필요하면 calculator 도구를 사용하세요
        - 현재 시간이 필요하면 get_current_time 도구를 사용하세요

        모든 답변은 한국어로 해주세요."""
    )

    # 시스템 프롬프트 + 기존 메시지들을 함께 모델에 전달
    messages = [system_prompt] + state["messages"]

    # AI 모델 호출
    response = get_model(
        tools=[search_weather, calculator, get_current_time]).invoke(messages, config)

    # 응답을 리스트로 반환 (기존 메시지 리스트에 추가되도록)
    return {"messages": [response]}

# 도구 실행 노드 정의
def tool_node(state: AgentState):
    """
    AI가 요청한 도구들을 실행하는 노드입니다.
    """

    outputs = []
    # 마지막 메시지에서 도구 호출 정보를 가져옵니다
    # last_message -> AI(LLM)의 답변 메세지 
    last_message = state["messages"][-1]

    # 각 도구 호출에 대해 실행
    # tool_calls -> AI의 답변을 생성할 때 사용한 tool 정보가 저장되어 있음 
    for tool_call in last_message.tool_calls:
        tool_name = tool_call["name"] # tool 이름
        tool_args = tool_call["args"] # tool을 호출할때 사용한 파라미터 정보 

        # 해당 도구 실행
        tools_by_name = {tool.name: tool for tool in [search_weather, calculator, get_current_time]}
        tool_result = tools_by_name[tool_name].invoke(tool_args)

        # 도구 결과를 ToolMessage로 변환
        outputs.append(
            ToolMessage(
                content=json.dumps(tool_result), # json.dumps(): 딕셔너리(JSON) 객체를 문자열로 변환 
                name=tool_name,
                tool_call_id=tool_call["id"],
            )
        )

    return {"messages": outputs}



