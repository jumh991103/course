from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
from utils import validate_date

def get_utc_offset_from_timezone(timezone_str, dt=None):
    """
    주어진 타임존 문자열과 datetime을 기반으로 UTC 오프셋(시간)을 반환합니다.
    
    Args:
        timezone_str (str): 예) 'Asia/Seoul'
        dt (datetime): 기준 datetime (없으면 현재 시간)
    
    Returns:
        int: UTC 오프셋(시간)
    """
    try:
        tz = ZoneInfo(timezone_str)
    except Exception:
        print(f"잘못된 타임존입니다: {timezone_str}")
        return None

    if dt is None:
        dt = datetime.now()

    # UTC 오프셋을 timedelta로 반환 -> 시간 단위로 변환
    offset_timedelta = tz.utcoffset(dt)
    return int(offset_timedelta.total_seconds() // 3600)


def convert_timezone_simple(datetime_str, from_timezone, to_timezone):
    """
    시간대를 변환합니다.
    
    Args:
        datetime_str (str): 날짜시간 (YYYY-MM-DD HH:MM)
        from_timezone (str): 원본 시간대 (예: 'Asia/Seoul')
        to_timezone (str): 변환할 시간대 (예: 'America/New_York')
    
    Returns:
        dict: 시간대 변환 정보
    """

    if not validate_date(date_str=datetime_str, format="%Y-%m-%d %H:%M"):
        print("올바른 날짜 형식을 입력하세요")
        return 

    dt = datetime.strptime(datetime_str, "%Y-%m-%d %H:%M")

    # 타임존 오프셋 가져오기
    from_offset = get_utc_offset_from_timezone(from_timezone, dt)
    to_offset = get_utc_offset_from_timezone(to_timezone, dt)

    if from_offset is None or to_offset is None:
        return
        
    # UTC로 변환
    utc_dt = dt - timedelta(hours=from_offset)
    
    # 목표 시간대로 변환
    target_dt = utc_dt + timedelta(hours=to_offset)
    
    time_diff = to_offset - from_offset
    
    print(f"시간대 변환 결과")
    print("=" * 50)
    print(f"원본 시간대 정보: {datetime_str} (UTC{'+' if from_offset >= 0 else ''}{from_offset})")
    print(f"변환된 시간대 정보: {target_dt.strftime('%Y-%m-%d %H:%M')} (UTC{'+' if to_offset >= 0 else ''}{to_offset})")
    print(f"시간 차이: {'+' if time_diff >= 0 else ''}{time_diff}시간")
    
    # 날짜 변경 체크
    original_date = datetime_str.split()[0]
    converted_date = target_dt.strftime("%Y-%m-%d")
    if original_date != converted_date:
        print(f"날짜 변경: {original_date} → {converted_date}")
    

if __name__ == "__main__":
    """
    한국 (KST): UTC+9 (항상 고정)
    뉴욕 (EST/EDT):
        겨울(표준시, EST) → UTC-5
        여름(서머타임, EDT) → UTC-4
    """
    print("테스트 4: 시간대 변환기")
    print("-" * 50)
    convert_timezone_simple(
        datetime_str="2024-03-15 14:30", from_timezone='Asia/Seoul', to_timezone='America/New_York')  # 한국 → 뉴욕

