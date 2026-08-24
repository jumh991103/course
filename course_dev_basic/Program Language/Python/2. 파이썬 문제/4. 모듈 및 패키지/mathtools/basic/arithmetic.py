def add(a:int, b:int) -> int:
    """
    두 수를 더합니다.
    
    Args:
        a (float): 첫 번째 수
        b (float): 두 번째 수
    
    Returns:
        float: a + b의 결과
    """
    if type(a) is not int or type(b) is not int:
        raise ValueError(f"'a'와 'b'는 int형이어야 합니다. 현재 타입: a={type(a).__name__}, b={type(b).__name__}")

    return a + b

def subtract(a:int, b:int) -> int:
    """
    첫 번째 수에서 두 번째 수를 뺍니다.
    
    Args:
        a (float): 첫 번째 수 (피감수)
        b (float): 두 번째 수 (감수)
    
    Returns:
        float: a - b의 결과
    """
    if type(a) is not int or type(b) is not int:
        raise ValueError(f"'a'와 'b'는 int형이어야 합니다. 현재 타입: a={type(a).__name__}, b={type(b).__name__}")
    
    return a - b

def multiply(a:int, b:int) -> int:
    """
    두 수를 곱합니다.
    
    Args:
        a (float): 첫 번째 수
        b (float): 두 번째 수
    
    Returns:
        float: a * b의 결과
    """
    if type(a) is not int or type(b) is not int:
        raise ValueError(f"'a'와 'b'는 int형이어야 합니다. 현재 타입: a={type(a).__name__}, b={type(b).__name__}")
    
    return a * b

def divide(a:int, b:int) -> int:
    """
    첫 번째 수를 두 번째 수로 나눕니다.
    
    Args:
        a (float): 첫 번째 수 (피제수)
        b (float): 두 번째 수 (제수)
    
    Returns:
        float: a / b의 결과
    
    Raises:
        ZeroDivisionError: b가 0일 때 발생
    """
    if type(a) is not int or type(b) is not int:
        raise ValueError(f"'a'와 'b'는 int형이어야 합니다. 현재 타입: a={type(a).__name__}, b={type(b).__name__}")
    elif b == 0:
        raise ZeroDivisionError("0으로 나눌 수 없습니다.")
    
    return a / b



if __name__ == "__main__":
    print("=== Arithmetic 모듈 테스트 ===")
    
    # 덧셈 테스트
    print(f"add(5, 3) = {add(5, 3)}")
    print(f"add(-2, 7) = {add(-2, 7)}")
    
    # 뺄셈 테스트
    print(f"subtract(10, 4) = {subtract(10, 4)}")
    print(f"subtract(3, 8) = {subtract(3, 8)}")
    
    # 곱셈 테스트
    print(f"multiply(6, 7) = {multiply(6, 7)}")
    print(f"multiply(-3, 4) = {multiply(-3, 4)}")
    
    # 나눗셈 테스트
    print(f"divide(15, 3) = {divide(15, 3)}")
    print(f"divide(7, 2) = {divide(7, 2)}")
