def find_excellent_students(students:list, threshold:int=80) -> list:
    """
    4. 모든 과목에서 80점 이상인 학생들의 이름을 리스트로 반환하는 함수
    
    Args:
        students (list): 학생 정보가 담긴 리스트
        threshold (int): 기준 점수 (기본값: 80)
    
    Returns:
        list: 모든 과목에서 기준점수 이상인 학생들의 이름 리스트
    """
    excellent_students = []
    
    for student in students:
        name = student["name"]
        subjects = student["subjects"]
        
        # 모든 과목의 점수가 기준점수 이상인지 확인
        all_above_threshold = all(score >= threshold for score in subjects.values())
        
        if all_above_threshold:
            excellent_students.append(name)
    
    return excellent_students

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
    
    print("4. 모든 과목에서 80점 이상인 학생들:")
    excellent_students = find_excellent_students(students)
    if excellent_students:
        for student in excellent_students:
            print(f"- {student}")
    else:
        print("해당하는 학생이 없습니다.")

