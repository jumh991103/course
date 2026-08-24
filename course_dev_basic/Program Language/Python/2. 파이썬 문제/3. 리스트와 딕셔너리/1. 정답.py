def calculate_student_averages(students:list) -> dict:
    """
    1. 각 학생의 평균 점수를 계산하여 딕셔너리로 반환하는 함수
    
    Args:
        students (list): 학생 정보가 담긴 리스트
    
    Returns:
        dict: {학생이름: 평균점수} 형태의 딕셔너리
    """
    averages = {}
    for student in students:
        name = student["name"]
        subjects = student["subjects"]
        # 모든 과목 점수의 평균 계산
        average = sum(subjects.values()) / len(subjects)
        averages[name] = round(average, 2)  # 소수점 둘째 자리까지 반올림
    
    return averages

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

    print("1. 각 학생의 평균 점수:")
    student_averages = calculate_student_averages(students)
    for name, avg in student_averages.items():
        print(f"{name}: {avg}점")

