
from mathtools.basic.arithmetic import add, subtract, multiply, divide
from mathtools.basic.geometry import circle_area, rectangle_area, triangle_area
from mathtools.advanced.statistics import mean, median, variance, standard_deviation


if __name__ == "__main__":
    print("=== Arithmetic 모듈 테스트 ===")
    # 덧셈 테스트
    print(f"add(5, 3) = {add(5, 3)}")
    # 뺄셈 테스트
    print(f"subtract(10, 4) = {subtract(10, 4)}")
    # 곱셈 테스트
    print(f"multiply(6, 7) = {multiply(6, 7)}")
    # 나눗셈 테스트
    print(f"divide(15, 3) = {divide(15, 3)}")

    print("=== Geometry 모듈 테스트 ===")
    # 원 관련 테스트
    print(f"원의 넓이(3) = {circle_area(3):.2f}")
    # 직사각형 관련 테스트
    print(f"직사각형 넓이(4, 6) = {rectangle_area(4, 6)}")
    # 삼각형 관련 테스트
    print(f"삼각형 넓이(6, 4) = {triangle_area(6, 4)}")


    print("=== Statistics 모듈 테스트 ===")
    test_data = [1, 2, 3, 4, 5, 5, 6, 7, 8, 9]
    print(f"테스트 데이터: {test_data}")
    print(f"평균: {mean(test_data):.2f}")
    print(f"중앙값: {median(test_data)}")
    print(f"분산(표본): {variance(test_data):.2f}")
    print(f"표준편차(표본): {standard_deviation(test_data):.2f}")