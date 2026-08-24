
-- 문제 1 정답: 특정 도시의 사무실 찾기
-- WHERE에서 city 값을 비교해 San Francisco 사무실만 조회합니다.
SELECT 
  *
FROM offices
WHERE 1=1
  AND city = 'San Francisco';

-- 문제 2 정답: 재고가 부족한 제품 찾기
-- quantityInStock이 100보다 작은 상품은 재고 보충 후보로 볼 수 있습니다.
SELECT 
    productCode
  , productName
  , quantityInStock
FROM products
WHERE 1=1
  AND quantityInStock < 100;

-- 문제 3 정답: 주문 상태 확인하기
-- status가 'Shipped'인 주문만 골라 배송 완료/발송 상태를 확인합니다.
SELECT 
    orderNumber
  , orderDate
  , status
FROM orders
WHERE 1=1
  AND status = 'Shipped';
