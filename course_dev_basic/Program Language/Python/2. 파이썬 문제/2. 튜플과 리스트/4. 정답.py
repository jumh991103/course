import math

# 테스트 및 실행 예시
if __name__ == "__main__":

  # 주어진 좌표 데이터 (x, y) 형태의 튜플 리스트
  points = [(1, 2), (3, 4), (-1, 5), (2, -3), (0, 0), (4, 1), (-2, -2)]
  print(f"원본 좌표 데이터: {points}")

  print("4. 각 점의 원점으로부터의 거리:")
  distances = [math.sqrt(x**2 + y**2) for x, y in points]
  print("상세 정보:")
  for i, ((x, y), distance) in enumerate(zip(points, distances)):
    print(f"{i+1}. ({x}, {y}) -> 거리: {distance:.2f}")
