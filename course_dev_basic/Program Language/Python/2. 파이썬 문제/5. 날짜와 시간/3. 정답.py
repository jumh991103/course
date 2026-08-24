from datetime import datetime, timedelta
from utils import validate_date, get_weekday_name, get_holidays_of_2024

def __get_all_holidays(holidays):
    # 공휴일 처리
    if holidays is None:
        holidays = []
    
    all_holidays = set(holidays)
    for holiday_date in get_holidays_of_2024():
        all_holidays.add(holiday_date)

    return all_holidays

def __calculate_milestones(milestones, working_days_count, milestone_targets, date_str, current_date):
    if working_days_count == milestone_targets[0] and 25 not in milestones:
        milestones[25] = {
            'date': date_str,
            'weekday': get_weekday_name(current_date.weekday())
        }
    elif working_days_count == milestone_targets[1] and 50 not in milestones:
        milestones[50] = {
            'date': date_str,
            'weekday': get_weekday_name(current_date.weekday())
        }
    elif working_days_count == milestone_targets[2] and 75 not in milestones:
        milestones[75] = {
            'date': date_str,
            'weekday': get_weekday_name(current_date.weekday())
        }

    return milestones


def __calculate_schedule(current_date, total_days, all_holidays, working_days_count
                        , milestones, milestone_targets, weekends, holidays_count):
    date_str = current_date.strftime("%Y-%m-%d")
    is_weekend = current_date.weekday() >= 5
    is_holiday = date_str in all_holidays
    
    if not is_weekend and not is_holiday:
        working_days_count += 1
        
        # 마일스톤 체크
        milestones = __calculate_milestones(milestones, working_days_count, milestone_targets, date_str, current_date)
    
    if is_weekend:
        weekends += 1
    if is_holiday:
        holidays_count += 1
    
    total_days += 1
    current_date += timedelta(days=1)

    return current_date, total_days, all_holidays, working_days_count, milestones, milestone_targets, weekends, holidays_count


def calculate_project_schedule(start_date, duration_days, holidays=None):
    """
    프로젝트 시작일과 소요 기간으로 완료일을 계산합니다.
    
    Args:
        start_date (str): 프로젝트 시작일
        duration_days (int): 소요 근무일
        holidays (list): 공휴일 리스트
    
    Returns:
        dict: 프로젝트 일정 정보
    """
    
    if not validate_date(start_date):
        print("올바른 날짜 형식을 입력하세요")
        return {}
    
    if duration_days <= 0:
        print("소요 기간은 0보다 커야 합니다")
        return {}
    
    start_dt = datetime.strptime(start_date, "%Y-%m-%d").date()
    all_holidays = __get_all_holidays(holidays)
    
    # 근무일 계산하여 완료일 찾기
    current_date = start_dt
    working_days_count = 0
    total_days = 0
    weekends = 0
    holidays_count = 0
    
    # 마일스톤 추적 (25%, 50%, 75%)
    milestones = {}
    milestone_targets = [
        int(duration_days * 0.25),
        int(duration_days * 0.50),
        int(duration_days * 0.75)
    ]
    
    while working_days_count < duration_days:
        current_date, total_days, all_holidays, working_days_count, milestones, milestone_targets, weekends, holidays_count = __calculate_schedule(
            current_date, total_days, all_holidays, working_days_count, milestones, milestone_targets, weekends, holidays_count)
    
    end_date = current_date - timedelta(days=1)
    
    # 100% 완료 추가
    milestones[100] = {
        'date': end_date.strftime("%Y-%m-%d"),
        'weekday': get_weekday_name(end_date.weekday())
    }
    
    return {
        'start_date': start_date,
        'start_weekday': get_weekday_name(start_dt.weekday()),
        'end_date': end_date.strftime("%Y-%m-%d"),
        'end_weekday': get_weekday_name(end_date.weekday()),
        'duration_days': duration_days,
        'total_days': total_days,
        'weekends': weekends,
        'holidays_count': holidays_count,
        'milestones': milestones
    }
    
if __name__ == "__main__":
    print("테스트 3: 프로젝트 일정 관리기")
    print("-" * 50)
    start_date = "2024-03-01"
    project_schedule = calculate_project_schedule(start_date=start_date, duration_days=20)

    print(f"프로젝트 일정 계산 결과")
    print("=" * 50)
    print(f"시작일: {start_date} ({project_schedule['start_weekday']})")
    print(f"프로젝트 완료 예정일: {project_schedule['end_date']} ({project_schedule['end_weekday']})")
    print(f"소요 근무일: {project_schedule['duration_days']}일")
    print(f"총 달력 일수: {project_schedule['total_days']}일")
    print(f"프로젝트 기간 중 주말: {project_schedule['weekends']}일")
    print(f"프로젝트 기간 중 공휴일: {project_schedule['holidays_count']}일")
    
    print(f"마일스톤 일정:")
    milestones = project_schedule['milestones']
    for percentage in sorted(milestones.keys()):
        milestone = milestones[percentage]
        if percentage == 100:
            print(f"{percentage}% 완료: {milestone['date']} ({milestone['weekday']}) - 프로젝트 완료")
        else:
            print(f"{percentage}% 완료: {milestone['date']} ({milestone['weekday']})")
    
    efficiency = (project_schedule['duration_days'] / project_schedule['total_days']) * 100
    print(f"프로젝트 효율성(소요 근무일 / 총 달력 일수): {efficiency:.1f}%")
