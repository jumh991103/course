from datetime import datetime, date
from utils import validate_date, get_weekday_name

def __get_age(today, birth_dt):
    """만 나이 계산"""

    age = today.year - birth_dt.year
    if today.month < birth_dt.month or (today.month == birth_dt.month and today.day < birth_dt.day):
        age -= 1
    
    return age

def __get_days_to_birthday_and_birthday_passed(birth_dt, today):
    """다음 생일까지 남은 일수"""

    this_year_birthday = birth_dt.replace(year=today.year)
    if this_year_birthday < today:
        next_birthday = birth_dt.replace(year=today.year + 1)
        birthday_passed = True
    elif this_year_birthday == today:
        next_birthday = birth_dt.replace(year=today.year + 1)
        birthday_passed = False
    else:
        next_birthday = this_year_birthday
        birthday_passed = False
    
    return (next_birthday - today).days, birthday_passed

def calculate_age_info(birth_date:str) -> dict:
    """
    생년월일을 받아 나이 관련 정보를 계산합니다.
    
    Args:
        birth_date (str): 생년월일 (YYYY-MM-DD 형식)
    
    Returns:
        dict: 나이 정보 딕셔너리
    """

    if not validate_date(birth_date):
        print("올바른 날짜 형식을 입력하세요 (YYYY-MM-DD)")
        return {}
    
    birth_dt = datetime.strptime(birth_date, "%Y-%m-%d").date()
    today = date.today()
    
    if birth_dt > today:
        print("미래의 날짜는 입력할 수 없습니다")
        return {}
    
    # 만 나이 계산
    age = __get_age(today, birth_dt)
    # 태어난 요일
    birth_weekday = get_weekday_name(birth_dt.weekday())
    # 살아온 총 일수
    days_lived = (today - birth_dt).days
    # 다음 생일까지 남은 일수
    days_to_birthday, birthday_passed = __get_days_to_birthday_and_birthday_passed(birth_dt, today)
    
    return {
        'birth_date': birth_dt,
        'age': age,
        'birth_weekday': birth_weekday,
        'days_lived': days_lived,
        'days_to_birthday': days_to_birthday,
        'birthday_passed': birthday_passed
    }

    
if __name__ == "__main__":
    print("테스트 1: 나이 계산기")
    print("-" * 50)
    age_info = calculate_age_info("1990-05-15")

    # 결과 출력
    print(f"나이 계산 결과 (생년월일: {age_info['birth_date']})")
    print("=" * 50)
    print(f"만 나이: {age_info['age']}세")
    print(f"태어난 요일: {age_info['birth_weekday']}요일")
    print(f"살아온 총 일수: {age_info['days_lived']:,}일")
    print(f"올해 생일 통과: {'예' if age_info['birthday_passed'] else '아니오'}")
    if age_info['days_to_birthday'] == 0:
        print("🎉 오늘이 생일입니다! 축하합니다! 🎉")
    elif age_info['days_to_birthday'] <= 7:
        print(f"🎈 생일이 곧 다가옵니다! ({age_info['days_to_birthday']}일 후)")


    