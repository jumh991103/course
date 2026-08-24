import math

# 테스트 및 실행 예시
if __name__ == "__main__":

  # 주어진 좌표 데이터 (x, y) 형태의 튜플 리스트
  points = [(1, 2), (3, 4), (-1, 5), (2, -3), (0, 0), (4, 1), (-2, -2)]
  print(f"원본 좌표 데이터: {points}")

  print("1. 원점으로부터의 거리가 3 이하인 점들 필터링:")

  # 거리 공식: sqrt(x^2 + y^2)
  close_points = [(x, y) for x, y in points if math.sqrt(x**2 + y**2) <= 3]
  print(f"결과: {close_points}")

  # 각 점의 거리도 함께 출력
  print("상세 정보:")
  for x, y in points:
      distance = math.sqrt(x**2 + y**2)
      status = "포함" if distance <= 3 else "제외"
      print(f"({x}, {y}) - 거리: {distance:.2f} - {status}")

