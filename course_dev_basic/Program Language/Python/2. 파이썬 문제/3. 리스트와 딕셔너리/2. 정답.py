def calculate_subject_average(students:list, subject_name:str) -> float:
    """
    2. 특정 과목의 전체 학생 평균을 계산하는 함수
    
    Args:
        students (list): 학생 정보가 담긴 리스트
        subject_name (str): 평균을 구할 과목명
    
    Returns:
        float: 해당 과목의 전체 학생 평균점수
    """
    total_score = 0
    student_count = 0
    
    for student in students:
        if subject_name in student["subjects"]:
            total_score += student["subjects"][subject_name]
            student_count += 1
    
    if student_count == 0:
        return 0  # 해당 과목을 수강하는 학생이 없는 경우
    
    return round(total_score / student_count, 2)


# 테스트 및 실행 예시
if __name__ == "__main__":
    print("=== 학생 성적 관리 시스템 ===")
    
    # 주어진 데이터 구조
    students = [
        {"name": "김철수", "subjects": {"수학": 85, "영어": 90, "과학": 78}},
        {"name": "이영희", "subjects": {"수학": 92, "영어": 88, "과학": 95}},
        {"name": "박민수", "subjects": {"수학": 78, "영어": 85, "과학": 82}},
        {"name": "정지혜", "subjects": {"수학": 88, "영어": 92, "과학": 89}}
    ]
    
    print("2. 과목별 전체 학생 평균:")
    subjects_list = ["수학", "영어", "과학"]
    for subject in subjects_list:
        avg = calculate_subject_average(students, subject)
        print(f"{subject}: {avg}점")
    
    