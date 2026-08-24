def find_top_student(students:list) -> dict:
    """
    3. 가장 높은 평균 점수를 가진 학생을 찾는 함수
    
    Args:
        students (list): 학생 정보가 담긴 리스트
    
    Returns:
        dict: {"name": 학생이름, "average": 평균점수} 형태의 딕셔너리
    """
    if not students:
        return None
    
    top_student = None
    highest_average = 0
    
    # 각 학생의 평균을 계산하여 최고 평균 찾기
    for student in students:
        subjects = student["subjects"]
        average = sum(subjects.values()) / len(subjects)
        
        if average > highest_average:
            highest_average = average
            top_student = {
                "name": student["name"],
                "average": round(average, 2)
            }
    
    return top_student


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
    
    print("3. 최고 평균 점수 학생:")
    top_student = find_top_student(students)
    if top_student:
        print(f"{top_student['name']}: {top_student['average']}점")
    
