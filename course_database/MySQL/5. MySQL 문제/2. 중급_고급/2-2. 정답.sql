
-- 문제 1 정답: 특정 고객의 주문 내역 확인
-- customers와 orders는 customerNumber를 기준으로 연결됩니다.
SELECT 
    c.customerName
  , o.orderNumber
  , o.orderDate
  , o.status
FROM customers AS c
JOIN orders AS o
  ON c.customerNumber = o.customerNumber
WHERE 1=1
  AND c.customerName = 'Atelier graphique';

-- 문제 2 정답: 특정 제품 라인의 제품 목록 확인
-- products와 productlines는 productLine 컬럼을 기준으로 연결됩니다.
SELECT 
    p.productCode
  , p.productName
  , pl.productLine
FROM products AS p
JOIN productlines AS pl
  ON p.productLine = pl.productLine
WHERE 1=1
  AND pl.productLine = 'Classic Cars';

-- 문제 3 정답: 특정 고객의 결제 내역 조회
-- 결제 금액 조건까지 함께 사용해 특정 고객의 5000 이상 결제만 조회합니다.
SELECT 
    c.customerName
  , p.checkNumber
  , p.paymentDate
  , p.amount
FROM customers AS c
JOIN payments AS p
  ON c.customerNumber = p.customerNumber
WHERE 1=1
  AND c.customerName = 'Atelier graphique'
  AND p.amount >= 5000;
