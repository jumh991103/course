-- MySQL DQL 기초 01
-- 조건 조회: WHERE, ORDER BY, LIMIT
-- SELECT의 기본 읽기 흐름은 FROM -> WHERE -> SELECT -> ORDER BY -> LIMIT 순서로 이해하면 쉽습니다.

USE classicmodels;

-- ###############################################
-- 상품 목록 확인
-- ###############################################
-- LIMIT은 처음부터 많은 데이터를 보지 않도록 결과 개수를 제한합니다.
SELECT
    productCode,
    productName,
    productLine,
    buyPrice,
    MSRP
FROM products
ORDER BY productCode
LIMIT 10;

-- ###############################################
-- 필요한 컬럼만 선택하기
-- ###############################################
-- 실무에서는 SELECT *보다 필요한 컬럼만 고르는 습관이 좋습니다.
SELECT
    customerNumber,
    customerName,
    country,
    creditLimit
FROM customers
ORDER BY customerNumber
LIMIT 10;

-- ###############################################
-- 비교 조건: MSRP가 150 이상인 상품
-- ###############################################
-- WHERE는 조건을 만족하는 행만 남깁니다.
SELECT
    productCode,
    productName,
    MSRP
FROM products
WHERE 1=1
  AND MSRP >= 150
ORDER BY MSRP DESC, productName
LIMIT 20;

-- ###############################################
-- AND, OR 조건
-- ###############################################
-- OR는 둘 중 하나만 만족해도 조회되고, AND는 둘 다 만족해야 조회됩니다.
SELECT
    productName,
    productLine,
    quantityInStock,
    buyPrice
FROM products
WHERE 1=1
  AND ( productLine = 'Motorcycles' OR buyPrice >= 100 )
ORDER BY buyPrice DESC
LIMIT 20;

-- ###############################################
-- IN 조건
-- ###############################################
-- IN은 여러 값 중 하나와 일치하는지 확인할 때 사용합니다.
SELECT
    customerName,
    country
FROM customers
WHERE 1=1
  AND country IN ('USA', 'France', 'Japan')
ORDER BY country, customerName
LIMIT 30;

-- ###############################################
-- BETWEEN 조건
-- ###############################################
-- BETWEEN 50 AND 100은 50 이상 100 이하를 의미합니다.
SELECT
    productName,
    buyPrice
FROM products
WHERE 1=1
  AND buyPrice BETWEEN 50 AND 100
ORDER BY buyPrice, productName
LIMIT 20;

-- ###############################################
-- 문자열 패턴 검색
-- ###############################################
-- LIKE의 %는 앞뒤에 어떤 글자가 와도 된다는 뜻입니다.
SELECT
    productName,
    productLine
FROM products
WHERE 1=1
  AND productName LIKE '%Ford%'
ORDER BY productName;

-- ###############################################
-- NULL 조회
-- ###############################################
-- NULL은 값이 없음을 뜻하므로 = NULL이 아니라 IS NULL로 비교합니다.
SELECT
    orderNumber,
    orderDate,
    shippedDate,
    status
FROM orders
WHERE 1=1
  AND shippedDate IS NULL
ORDER BY orderDate;

-- ###############################################
-- LIMIT으로 일부만 조회
-- ###############################################
-- 정렬 기준을 먼저 정한 뒤 LIMIT을 쓰면 "상위 N개" 조회가 됩니다.
SELECT
    checkNumber,
    customerNumber,
    amount,
    paymentDate
FROM payments
ORDER BY amount DESC, paymentDate
LIMIT 10;
