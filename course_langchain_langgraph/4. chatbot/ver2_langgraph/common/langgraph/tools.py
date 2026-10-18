import subprocess 
import sys
from datetime import datetime
from langchain_tavily import TavilySearch
from langchain_core.tools import tool
from .model import get_model


def __get_tavily_search():
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
def search_weather(city) -> str:
    """특정 도시의 현재 날씨 정보를 검색합니다."""
    print("[호출] search_weather")
    try:    
        search_query = f"{city} 형재 날씨 온도"
        tavily_search = __get_tavily_search()
        result_weather = tavily_search.invoke(search_query)

        answer = get_model().invoke(f"{result_weather['answer']} 설명없이 한문장으로 번역해줘.")
        weather_info = f"""
        {city} 날씨 정보:
        {answer.content}

        출처: {result_weather['results'][0]['url']}
        """
        return weather_info

    except Exception as e:
        return f"{city}의 날씨 검색 중 오류가 발생했습니다: {str(e)}"

@tool
def calculator(expression: str) -> str:
    """수학 계산을 수행하는 도구입니다."""
    print("[호출] calculator")
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
    
@tool
def get_current_time() -> str:
    """현재 시간을 조회합니다."""
    print("[호출] get_current_time")
    now = datetime.now()
    return f"현재 시간: {now.strftime("%Y년 %m월 %d일 %H시 %M분")}"

