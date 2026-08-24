-- MySQL DQL 기초 04
-- 서브쿼리와 CTE
-- 서브쿼리는 SQL 안에 들어가는 또 다른 SELECT이고, CTE는 복잡한 조회를 단계별로 나누는 방법입니다.

USE classicmodels;

-- 평균 MSRP보다 비싼 상품
-- 괄호 안의 서브쿼리가 먼저 평균 가격을 계산하고, 바깥 쿼리가 그 값보다 비싼 상품을 찾습니다.
SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE MSRP > (
    SELECT AVG(MSRP)
    FROM products
)
ORDER BY MSRP DESC, productName;

-- Classic Cars 상품을 주문한 고객
-- IN 서브쿼리는 안쪽 조회 결과 목록에 포함된 고객만 남깁니다.
SELECT
    customerNumber,
    customerName,
    country
FROM customers
WHERE customerNumber IN (
    SELECT DISTINCT o.customerNumber
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products p ON od.productCode = p.productCode
    WHERE p.productLine = 'Classic Cars'
)
ORDER BY customerName;

-- 결제 기록이 있는 고객
-- EXISTS는 조건을 만족하는 관련 행이 하나라도 있는지 확인합니다.
SELECT
    customerNumber,
    customerName
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.customerNumber = c.customerNumber
)
ORDER BY customerName;

-- CTE로 고객별 주문 수를 먼저 계산한 뒤 조회
-- WITH 절에 이름을 붙여 두면 아래 SELECT에서 임시 테이블처럼 사용할 수 있습니다.
WITH customer_order_stats AS (
    SELECT
        c.customerNumber,
        c.customerName,
        COUNT(o.orderNumber) AS order_count
    FROM customers c
    LEFT JOIN orders o ON c.customerNumber = o.customerNumber
    GROUP BY c.customerNumber, c.customerName
)
SELECT
    customerNumber,
    customerName,
    order_count
FROM customer_order_stats
WHERE order_count >= 5
ORDER BY order_count DESC, customerName;

-- CTE 여러 단계 사용: 상품 라인별 매출
-- 첫 번째 CTE에서 주문 상세 금액을 만들고, 두 번째 CTE에서 상품 라인별로 합산합니다.
WITH order_amounts AS (
    SELECT
        p.productLine,
        od.quantityOrdered * od.priceEach AS line_amount
    FROM orderdetails od
    JOIN products p ON od.productCode = p.productCode
),
productline_sales AS (
    SELECT
        productLine,
        COUNT(*) AS line_count,
        SUM(line_amount) AS total_sales
    FROM order_amounts
    GROUP BY productLine
)
SELECT
    productLine,
    line_count,
    total_sales
FROM productline_sales
ORDER BY total_sales DESC;
