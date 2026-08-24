
-- 문제 1 정답: 고객별 총 결제 금액
-- 고객별로 결제 금액을 합산한 뒤 50000 이상인 고객만 남깁니다.
SELECT 
    c.customerName,
    SUM(p.amount) AS totalAmount
FROM customers AS c
JOIN payments AS p
  ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
HAVING SUM(p.amount) >= 50000
ORDER BY c.customerName ASC;

-- 문제 2 정답: 제품 라인별 총 판매 수량
-- 주문상세의 수량을 상품 라인별로 합산합니다.
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered) AS totalQuantity
FROM orderdetails AS od
JOIN orders AS o
  ON od.orderNumber = o.orderNumber
JOIN products AS p
  ON od.productCode = p.productCode
JOIN productlines AS pl
  ON p.productLine = pl.productLine
GROUP BY pl.productLine
HAVING SUM(od.quantityOrdered) >= 1000
ORDER BY totalQuantity DESC;

-- 문제 3 정답: 영업사원별 고객 수와 평균 결제 금액
-- DISTINCT로 같은 고객이 여러 결제를 해도 고객 수는 한 번만 세도록 합니다.
SELECT 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    COUNT(DISTINCT c.customerNumber) AS customerCount,
    AVG(p.amount) AS avgPayment
FROM employees AS e
JOIN customers AS c
  ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments AS p
  ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber
HAVING AVG(p.amount) >= 5000
ORDER BY avgPayment DESC;
