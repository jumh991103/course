import math

def circle_area(radius:float) -> float:
    """
    원의 넓이를 계산합니다.
    
    Args:
        radius (float): 원의 반지름
    
    Returns:
        float: 원의 넓이 (π * r²)
    
    Raises:
        ValueError: 반지름이 음수일 때 발생
    """
    if radius < 0:
        raise ValueError("반지름은 음수일 수 없습니다.")
    
    return math.pi * radius ** 2


def rectangle_area(width:float, height:float) -> float:
    """
    직사각형의 넓이를 계산합니다.
    
    Args:
        width (float): 직사각형의 가로 길이
        height (float): 직사각형의 세로 길이
    
    Returns:
        float: 직사각형의 넓이 (가로 * 세로)
    
    Raises:
        ValueError: 가로나 세로가 음수일 때 발생
    """
    if width < 0 or height < 0:
        raise ValueError("가로와 세로는 음수일 수 없습니다.")
    
    return width * height


def triangle_area(base:float, height:float) -> float:
    """
    삼각형의 넓이를 계산합니다.
    
    Args:
        base (float): 삼각형의 밑변 길이
        height (float): 삼각형의 높이
    
    Returns:
        float: 삼각형의 넓이 (밑변 * 높이 / 2)
    
    Raises:
        ValueError: 밑변이나 높이가 음수일 때 발생
    """
    if base < 0 or height < 0:
        raise ValueError("밑변과 높이는 음수일 수 없습니다.")
    
    return (base * height) / 2


if __name__ == "__main__":
    print("=== Geometry 모듈 테스트 ===")
    
    # 원 관련 테스트
    print(f"원의 넓이(3) = {circle_area(3):.2f}")
    
    # 직사각형 관련 테스트
    print(f"직사각형 넓이(4, 6) = {rectangle_area(4, 6)}")
    
    # 삼각형 관련 테스트
    print(f"삼각형 넓이(6, 4) = {triangle_area(6, 4)}")
