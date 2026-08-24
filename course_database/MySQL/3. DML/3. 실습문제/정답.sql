-- MySQL DML/DQL 기초 실습문제 정답

-- 문제 1. CRUD
-- examplesdb는 00_setup_sample_data.sql에서 만든 실습용 데이터베이스입니다.
USE examplesdb;

-- 문제 1-1 정답: 수강생 추가
-- INSERT: 실습용 학생 한 명을 추가합니다.
INSERT INTO students (name, email, birth_date, phone)
VALUES ('실습학생', 'practice@example.com', '2001-01-01', NULL);

-- 문제 1-2 정답: 추가한 수강생의 전화번호 수정
-- UPDATE: 방금 추가한 학생만 바꾸기 위해 email을 조건으로 사용합니다.
UPDATE students
SET phone = '010-9999-9999'
WHERE email = 'practice@example.com';

-- 문제 1-3 정답: 추가한 수강생 조회
-- SELECT: 수정 결과를 확인합니다.
SELECT
    student_id,
    name,
    email,
    phone
FROM students
WHERE email = 'practice@example.com';

-- 문제 1-4 정답: 추가한 수강생 삭제
-- DELETE: 실습 데이터가 남지 않도록 다시 삭제합니다.
DELETE FROM students
WHERE email = 'practice@example.com';

-- 문제 2. 조건 조회
-- classicmodels는 DQL 실습용 샘플 데이터베이스입니다.
USE classicmodels;

-- 문제 2-1 정답: MSRP가 150 이상인 상품 조회
-- 가격 조건 조회: MSRP가 150 이상인 상품만 남깁니다.
SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE MSRP >= 150
ORDER BY MSRP DESC, productName;

-- 문제 2-2 정답: Motorcycles 또는 Classic Cars 상품 조회
-- IN 조건 조회: 두 상품 라인 중 하나에 속하면 조회됩니다.
SELECT
    productCode,
    productName,
    productLine
FROM products
WHERE productLine IN ('Motorcycles', 'Classic Cars')
ORDER BY productLine, productName;

-- 문제 2-3 정답: 구매 가격이 50에서 100 사이인 상품 조회
-- BETWEEN 조건 조회: 50 이상 100 이하 범위의 구매 가격을 찾습니다.
SELECT
    productName,
    buyPrice
FROM products
WHERE buyPrice BETWEEN 50 AND 100
ORDER BY buyPrice, productName;

-- 문제 2-4 정답: 이름에 Ford가 포함된 상품 조회
-- LIKE 조건 조회: 상품명 안에 Ford가 들어간 상품을 찾습니다.
SELECT
    productName,
    productLine
FROM products
WHERE productName LIKE '%Ford%'
ORDER BY productName;

-- 문제 3. 집계
-- 문제 3-1 정답: 상품 라인별 상품 수 조회
-- GROUP BY: productLine별로 행을 묶고 COUNT로 개수를 셉니다.
SELECT
    productLine,
    COUNT(*) AS product_count
FROM products
GROUP BY productLine
ORDER BY product_count DESC, productLine;

-- 문제 3-2 정답: 상품 라인별 평균 구매 가격 조회
-- AVG: 상품 라인별 평균 구매 가격을 계산합니다.
SELECT
    productLine,
    ROUND(AVG(buyPrice), 2) AS average_buy_price
FROM products
GROUP BY productLine
ORDER BY average_buy_price DESC;

-- 문제 3-3 정답: 고객별 총 결제 금액 조회
-- SUM: 고객별 총 결제 금액을 계산합니다.
SELECT
    customerNumber,
    SUM(amount) AS total_amount
FROM payments
GROUP BY customerNumber
ORDER BY total_amount DESC;

-- 문제 3-4 정답: 주문 수가 5건 이상인 고객 조회
-- HAVING: 주문 수를 집계한 뒤 5건 이상인 고객만 남깁니다.
SELECT
    customerNumber,
    COUNT(*) AS order_count
FROM orders
GROUP BY customerNumber
HAVING COUNT(*) >= 5
ORDER BY order_count DESC, customerNumber;

-- 문제 4. 조인
-- 문제 4-1 정답: 주문번호, 고객명, 주문일, 주문 상태 조회
-- 고객 번호를 기준으로 주문과 고객 정보를 연결합니다.
SELECT
    o.orderNumber,
    c.customerName,
    o.orderDate,
    o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
ORDER BY o.orderDate DESC;

-- 문제 4-2 정답: 고객명, 주문번호, 상품명, 주문 수량, 판매 가격 조회
-- 주문 상세는 고객 -> 주문 -> 주문상세 -> 상품 순서로 연결합니다.
SELECT
    c.customerName,
    o.orderNumber,
    p.productName,
    od.quantityOrdered,
    od.priceEach
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
ORDER BY o.orderNumber, od.orderLineNumber;

-- 문제 4-3 정답: 상품 라인별 상품 수 조회
-- LEFT JOIN으로 상품이 없는 상품 라인도 결과에 남길 수 있습니다.
SELECT
    pl.productLine,
    COUNT(p.productCode) AS product_count
FROM productlines pl
LEFT JOIN products p ON pl.productLine = p.productLine
GROUP BY pl.productLine
ORDER BY product_count DESC, pl.productLine;

-- 문제 4-4 정답: 고객명, 담당 직원명, 담당 직원의 사무실 도시 조회
-- 고객을 담당 직원, 사무실 정보와 연결합니다.
SELECT
    c.customerName,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    o.city AS office_city
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY c.customerName;

-- 문제 5. 서브쿼리와 CTE
-- 문제 5-1 정답: 평균 MSRP보다 비싼 상품 조회
-- 평균 MSRP는 서브쿼리에서 먼저 계산됩니다.
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

-- 문제 5-2 정답: Classic Cars 상품을 주문한 고객을 서브쿼리로 조회
-- Classic Cars를 주문한 고객 번호 목록을 서브쿼리에서 만들고, 바깥 쿼리에서 고객 정보를 조회합니다.
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

-- 문제 5-3 정답: 결제 기록이 있는 고객을 EXISTS로 조회
-- EXISTS는 결제 기록이 하나라도 존재하는 고객만 조회합니다.
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

-- 문제 5-4 정답: CTE로 고객별 주문 수 계산 후 5건 이상인 고객 조회
-- CTE로 고객별 주문 수를 먼저 만들고, 최종 SELECT에서 조건을 적용합니다.
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
