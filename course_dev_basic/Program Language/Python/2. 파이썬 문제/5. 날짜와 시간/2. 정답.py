from datetime import datetime, timedelta
from utils import validate_date, get_weekday_name, get_holidays_of_2024

def __get_all_holidays(holidays, start_dt, end_dt):
    """공휴일 처리"""
    if holidays is None:
        holidays = []

    # 기본 공휴일 추가
    all_holidays = set(holidays)
    for holiday_date in get_holidays_of_2024():
        if start_dt <= datetime.strptime(holiday_date, "%Y-%m-%d").date() <= end_dt:
            all_holidays.add(holiday_date)

    return all_holidays


def __analysis_days(current_date, end_dt, all_holidays):
    """날짜별 분석"""
    total_days = 0
    working_days = 0
    weekend_dates = []
    holiday_dates = []
    
    while current_date <= end_dt:
        total_days += 1
        date_str = current_date.strftime("%Y-%m-%d")
        is_weekend = current_date.weekday() >= 5  # 토(5), 일(6)
        is_holiday = date_str in all_holidays
        
        if is_weekend:
            weekend_dates.append({
                'date': date_str,
                'weekday': get_weekday_name(current_date.weekday())
            })
        
        if is_holiday:
            holiday_name = get_holidays_of_2024().get(date_str, "공휴일")
            holiday_dates.append({
                'date': date_str,
                'name': holiday_name,
                'weekday': get_weekday_name(current_date.weekday())
            })
        
        # 근무일: 주말도 아니고 공휴일도 아닌 날
        if not is_weekend and not is_holiday:
            working_days += 1
        
        current_date += timedelta(days=1)

    return {
        'total_days': total_days,
        'working_days': working_days,
        'weekends': weekend_dates,
        'holidays': holiday_dates
    }


def __print_analysis_days(analysis_days):
    weekend_dates = analysis_days['weekends']
    if weekend_dates:
        print(f"주말 목록 (처음 5개):")
        for weekend in weekend_dates[:5]:
            print(f"  {weekend['date']} ({weekend['weekday']})")
        if len(weekend_dates) > 5:
            print(f"  ... 외 {len(weekend_dates) - 5}개")
    
    holiday_dates = analysis_days['holidays']
    if holiday_dates:
        print(f"공휴일 목록:")
        for holiday in holiday_dates:
            print(f"  {holiday['date']} ({holiday['weekday']}) - {holiday['name']}")
    
    # 근무일 비율
    ratio = (analysis_days['working_days'] / analysis_days['total_days']) * 100
    print(f"근무일 비율: {ratio:.1f}%")


def calculate_working_days(start_date:str, end_date:str, holidays=None) -> dict:
    """
    두 날짜 사이의 근무일(평일)을 계산합니다.
    
    Args:
        start_date (str): 시작일 (YYYY-MM-DD)
        end_date (str): 종료일 (YYYY-MM-DD)
        holidays (list): 공휴일 리스트 (선택사항)
    
    Returns:
        dict: 근무일 관련 정보
    """
    
    if not validate_date(start_date) or not validate_date(end_date):
        print("올바른 날짜 형식을 입력하세요")
        return {}
    
    start_dt = datetime.strptime(start_date, "%Y-%m-%d").date()
    end_dt = datetime.strptime(end_date, "%Y-%m-%d").date()
    
    if start_dt > end_dt:
        print("시작일이 종료일보다 늦습니다")
        return {}
    
    # 공휴일 처리
    all_holidays = __get_all_holidays(holidays, start_dt, end_dt)
    
    # 날짜별 분석
    analysis_days = __analysis_days(current_date=start_dt, end_dt=end_dt, all_holidays=all_holidays)
    
    # 분석 결과 프린트
    __print_analysis_days(analysis_days)
    
    return analysis_days
    
if __name__ == "__main__":
    print("테스트 2: 근무일 계산기")
    print("-" * 50)
    start_date="2024-03-01"
    end_date="2024-03-31"
    working_days = calculate_working_days(start_date=start_date, end_date=end_date)

    # 결과 출력
    print(f"근무일 계산 결과 ({start_date} ~ {end_date})")
    print("=" * 50)
    print(f"총 일수: {working_days['total_days']}일")
    print(f"주말 수: {len(working_days['weekends'])}일")
    print(f"공휴일 수: {len(working_days['holidays'])}일")
    print(f"실제 근무일 (주말 + 공휴일 제외): {working_days['working_days']}일")

