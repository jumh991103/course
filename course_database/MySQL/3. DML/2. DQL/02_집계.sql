-- MySQL DQL 기초 02
-- 집계: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- 집계 함수는 여러 행을 하나의 요약 값으로 계산할 때 사용합니다.

USE classicmodels;

-- 전체 상품 수
-- COUNT(*)는 조건에 맞는 행의 개수를 셉니다.
SELECT COUNT(*) AS product_count
FROM products;

-- 상품 라인별 상품 수
-- GROUP BY는 같은 productLine 값을 가진 행끼리 묶어 집계합니다.
SELECT
    productLine,
    COUNT(*) AS product_count
FROM products
GROUP BY productLine
ORDER BY product_count DESC, productLine;

-- 상품 라인별 가격 통계
-- AVG, MIN, MAX로 그룹별 평균값, 최솟값, 최댓값을 구합니다.
SELECT
    productLine,
    COUNT(*) AS product_count,
    ROUND(AVG(buyPrice), 2) AS average_buy_price,
    MIN(buyPrice) AS min_buy_price,
    MAX(buyPrice) AS max_buy_price
FROM products
GROUP BY productLine
ORDER BY average_buy_price DESC;

-- 고객별 결제 금액
-- SUM(amount)는 고객별 총 결제 금액을 계산합니다.
SELECT
    customerNumber,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM payments
GROUP BY customerNumber
ORDER BY total_amount DESC
LIMIT 20;

-- HAVING: 집계 결과에 조건 적용
-- WHERE는 집계 전에 행을 거르고, HAVING은 GROUP BY 이후의 집계 결과를 거릅니다.
SELECT
    customerNumber,
    COUNT(*) AS order_count
FROM orders
GROUP BY customerNumber
HAVING COUNT(*) >= 5
ORDER BY order_count DESC, customerNumber;

-- 월별 매출
-- DATE_FORMAT으로 날짜를 월 단위 문자열로 바꾼 뒤 월별로 묶습니다.
SELECT
    DATE_FORMAT(paymentDate, '%Y-%m-01') AS payment_month,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount
FROM payments
GROUP BY DATE_FORMAT(paymentDate, '%Y-%m-01')
ORDER BY payment_month;
