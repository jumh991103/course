import math

# 테스트 및 실행 예시
if __name__ == "__main__":

  # 주어진 좌표 데이터 (x, y) 형태의 튜플 리스트
  points = [(1, 2), (3, 4), (-1, 5), (2, -3), (0, 0), (4, 1), (-2, -2)]
  print(f"원본 좌표 데이터: {points}")

  print("3. 1사분면에 있는 점들의 개수:")
  first_quadrant_points = [(x, y) for x, y in points if x > 0 and y > 0]
  first_quadrant_count = len(first_quadrant_points)
  print(f"1사분면 점들: {first_quadrant_points}")
  print(f"개수: {first_quadrant_count}개")
  