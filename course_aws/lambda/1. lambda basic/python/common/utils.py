from datetime import datetime, timedelta, timezone

def get_now() -> datetime:
    KST = timezone(timedelta(hours=9))
    return datetime.now(tz=KST)

def get_str_now(format:str="%Y-%m-%d %H:%M:%S") -> str:
    """
    Get the current date and time as a string in the specified format.
      %Y는 4자리 년도인 2008이 됩니다.
      %y는 2자리 년도인 08이 됩니다.
      %m은 0이 채워진 두 자리 수의 월이므로 08이 됩니다.
      %d는 0이 채워진 두 자리 수의 일이므로 03이 됩니다.
      %H는 0이 채워진 두 자리 수의 시를 의미하므로 05가 됩니다.
      %M은 0이 채워진 두 자리 수의 분을 의미하므로 11이 됩니다.
      %S는 0이 채워진 두 자리 수의 초를 의미하므로 03이 됩니다.
    """
    return get_now().strftime(format)

