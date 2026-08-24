import math

# 테스트 및 실행 예시
if __name__ == "__main__":

  # 주어진 좌표 데이터 (x, y) 형태의 튜플 리스트
  points = [(1, 2), (3, 4), (-1, 5), (2, -3), (0, 0), (4, 1), (-2, -2)]
  print(f"원본 좌표 데이터: {points}")

  print("2. x축 기준으로 대칭 이동 (y 좌표의 부호 변경):")
  # x축 대칭: (x, y) -> (x, -y)
  x_symmetric_points = [(x, -y) for x, y in points]
  print(f"   원본: {points}")
  print(f"   결과: {x_symmetric_points}")