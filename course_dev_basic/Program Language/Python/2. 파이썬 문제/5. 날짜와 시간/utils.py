from datetime import datetime

def validate_date(date_str:str, format="%Y-%m-%d") -> bool:
    """날짜 형식 검증"""
    try:
        datetime.strptime(date_str, format)
        return True
    except ValueError:
        return False


def get_weekday_name(index:int) -> str:
    """한국어 요일/월 이름"""
    WEEKDAY_NAMES = ["월", "화", "수", "목", "금", "토", "일"]
    return WEEKDAY_NAMES[index]

def get_holidays_of_2024() -> dict:
    """한국 공휴일 (2024년)"""
    return {
        "2024-01-01": "신정", "2024-03-01": "삼일절", "2024-05-05": "어린이날",
        "2024-06-06": "현충일", "2024-08-15": "광복절", "2024-10-03": "개천절",
        "2024-10-09": "한글날", "2024-12-25": "크리스마스"
    }
