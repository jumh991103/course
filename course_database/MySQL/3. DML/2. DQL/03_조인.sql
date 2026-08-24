-- MySQL DQL 기초 03
-- 조인: INNER JOIN, LEFT JOIN, SELF JOIN
-- JOIN은 서로 다른 테이블에 나뉘어 저장된 데이터를 연결해서 조회할 때 사용합니다.

USE classicmodels;

-- 주문 목록: 고객 + 주문
-- orders.customerNumber와 customers.customerNumber가 같은 행끼리 연결합니다.
SELECT
    o.orderNumber,
    c.customerName,
    o.orderDate,
    o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
ORDER BY o.orderDate DESC
LIMIT 20;

-- 주문 상세: 고객 + 주문 + 상품
-- 테이블이 여러 개일수록 별칭(c, o, od, p)을 사용하면 SQL이 짧고 읽기 쉬워집니다.
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
ORDER BY o.orderNumber, od.orderLineNumber
LIMIT 30;

-- 상품 라인별 상품 수: 상품이 없는 라인도 확인할 수 있도록 LEFT JOIN 사용
-- LEFT JOIN은 왼쪽 테이블(productlines)의 행을 모두 남깁니다.
SELECT
    pl.productLine,
    COUNT(p.productCode) AS product_count
FROM productlines pl
LEFT JOIN products p ON pl.productLine = p.productLine
GROUP BY pl.productLine
ORDER BY product_count DESC, pl.productLine;

-- 고객 담당 직원과 사무실
-- 고객 -> 직원 -> 사무실처럼 관계를 따라가며 필요한 정보를 가져옵니다.
SELECT
    c.customerName,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    e.jobTitle,
    o.city AS office_city,
    o.country AS office_country
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o ON e.officeCode = o.officeCode
ORDER BY c.customerName
LIMIT 30;

-- SELF JOIN: 직원과 상급자
-- 같은 employees 테이블을 직원(e)과 매니저(m)라는 두 역할로 나누어 조인합니다.
SELECT
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
    e.jobTitle,
    CONCAT(m.firstName, ' ', m.lastName) AS manager_name
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber
ORDER BY manager_name, employee_name;
