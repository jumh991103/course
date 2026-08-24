import math

def mean(data:list) -> float:
    """
    데이터의 평균(산술평균)을 계산합니다.
    
    Args:
        data (list): 숫자들의 리스트
    
    Returns:
        float: 평균값
    
    Raises:
        ValueError: 빈 리스트가 입력되었을 때 발생
    """
    if not data:
        raise ValueError("빈 리스트에 대해서는 평균을 계산할 수 없습니다.")
    return sum(data) / len(data)

def median(data:list) -> float:
    """
    데이터의 중앙값을 계산합니다.
    
    Args:
        data (list): 숫자들의 리스트
    
    Returns:
        float: 중앙값
    
    Raises:
        ValueError: 빈 리스트가 입력되었을 때 발생
    """
    if not data:
        raise ValueError("빈 리스트에 대해서는 중앙값을 계산할 수 없습니다.")
    
    sorted_data = sorted(data)
    n = len(sorted_data)
    
    if n % 2 == 1:
        # 홀수 개인 경우: 가운데 값
        return sorted_data[n // 2]
    else:
        # 짝수 개인 경우: 가운데 두 값의 평균
        mid1 = sorted_data[n // 2 - 1]
        mid2 = sorted_data[n // 2]
        return (mid1 + mid2) / 2

def variance(data:list, sample:bool=True) -> float:
    """
    데이터의 분산을 계산합니다.
    
    Args:
        data (list): 숫자들의 리스트
        sample (bool): True면 표본분산, False면 모집단분산
    
    Returns:
        float: 분산값
    
    Raises:
        ValueError: 빈 리스트가 입력되거나 표본분산 계산 시 데이터가 1개일 때 발생
    """
    if not data:
        raise ValueError("빈 리스트에 대해서는 분산을 계산할 수 없습니다.")
    
    if sample and len(data) < 2:
        raise ValueError("표본분산 계산을 위해서는 최소 2개의 데이터가 필요합니다.")
    
    data_mean = mean(data)
    squared_deviations = [(x - data_mean) ** 2 for x in data]
    
    if sample:
        # 표본분산 (n-1로 나눔)
        return sum(squared_deviations) / (len(data) - 1)
    else:
        # 모집단분산 (n으로 나눔)
        return sum(squared_deviations) / len(data)

def standard_deviation(data:list, sample:bool=True) -> float:
    """
    데이터의 표준편차를 계산합니다.
    
    Args:
        data (list): 숫자들의 리스트
        sample (bool): True면 표본표준편차, False면 모집단표준편차
    
    Returns:
        float: 표준편차값
    
    Raises:
        ValueError: 빈 리스트가 입력되거나 표본표준편차 계산 시 데이터가 1개일 때 발생
    """
    return math.sqrt(variance(data, sample))



if __name__ == "__main__":
    print("=== Statistics 모듈 테스트 ===")
    
    test_data = [1, 2, 3, 4, 5, 5, 6, 7, 8, 9]
    
    print(f"테스트 데이터: {test_data}")
    print(f"평균: {mean(test_data):.2f}")
    print(f"중앙값: {median(test_data)}")
    print(f"분산(표본): {variance(test_data):.2f}")
    print(f"분산(모집단): {variance(test_data, sample=False):.2f}")
    print(f"표준편차(표본): {standard_deviation(test_data):.2f}")
    print(f"표준편차(모집단): {standard_deviation(test_data, sample=False):.2f}")
