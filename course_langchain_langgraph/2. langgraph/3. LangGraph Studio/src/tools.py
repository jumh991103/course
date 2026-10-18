import subprocess
import sys
from langchain_core.tools import tool
from langchain_tavily import TavilySearch
from pydantic import BaseModel, Field
from datetime import datetime, timedelta

from src.models import get_ChatOpenAI

def get_available_tools():
    return [calculator, get_weather, schedule_reminder]

@tool
def calculator(expression: str) -> str:
    """
    수학 계산을 수행하는 도구입니다.
    """
    try:
        # 안전을 위해 허용된 문자만 통과
        allowed_chars = "0123456789+-*/.%() "
        if not all(c in allowed_chars for c in expression):
            return "오류: 허용되지 않는 문자가 포함되어 있습니다."

        python_exec = "python3" if sys.platform != "win32" else "python"

        # subprocess를 이용해 별도 Python 프로세스에서 계산 수행
        result = subprocess.run(
            [python_exec, "-c", f"print({expression})"],
            capture_output=True,
            text=True,
            timeout=3  # 무한 루프 방지
        )

        if result.returncode != 0:
            return f"계산 오류: {result.stderr.strip()}"
        
        return f"계산 결과: {expression} = {result.stdout.strip()}"

    except subprocess.TimeoutExpired:
        return "계산 오류: 계산이 너무 오래 걸립니다."
    except Exception as e:
        return f"계산 오류: {str(e)}"


def __get_TavilySearch():
    return TavilySearch(
        max_results=3,
        topic="general",               # 또는 "news", "finance" 등
        include_answer=True,           # 답변 포함 여부
        include_raw_content=False,     # 원본 내용 포함 여부
        include_images=False,          # 이미지 포함 여부
        search_depth="basic",          # "basic" 또는 "advanced"
        include_domains=[
            "https://weather.daum.net/",
            "https://www.weatheri.co.kr/" 
        ],
        exclude_domains=None            # 필요하면 제외 도메인 지정 가능
    )

@tool  
def get_weather(city: str) -> str:
    """특정 도시의 현재 날씨 정보를 검색합니다."""
    try:
        search_query = f"{city} 현재 날씨 기온"
        result_weather = __get_TavilySearch().invoke(search_query)
        
        if not result_weather['answer'] or len(result_weather['results']) < 1:
            return f"'{city}'의 날씨 정보를 찾을 수 없습니다."
        
        # 첫 번째 결과에서 날씨 정보 추출
        answer = get_ChatOpenAI().invoke(f"{result_weather['answer']} 설명없이 한문장으로 번역해줘.")
        weather_info = f"""
        {city} 날씨 정보:
        {answer.content}

        출처: {result_weather['results'][0]['url']}
        """
        
        return weather_info
        
    except Exception as e:
        return f"날씨 정보 검색 중 오류가 발생했습니다: {str(e)}"

class ReminderInput(BaseModel):
    task: str = Field(description="할 일 내용")
    hours_from_now: int = Field(description="현재부터 몇 시간 후에 알림할지")

@tool("new_schedule_reminder", args_schema=ReminderInput, return_direct=True)
def schedule_reminder(task: str, hours_from_now: int) -> str:
    """
    할 일 알림을 스케줄링하는 도구입니다.
    task: 할 일 내용입니다.
    hours_from_now: 현재부터 몇 시간 후에 알림할지입니다.
    """
    reminder_time = datetime.now() + timedelta(hours=hours_from_now)
    return f"알림 설정 완료: '{task}' - {reminder_time.strftime('%Y-%m-%d %H:%M')}에 알림됩니다."

