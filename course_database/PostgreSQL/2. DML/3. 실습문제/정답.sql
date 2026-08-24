-- PostgreSQL DML/DQL 기초 실습문제 정답

-- 문제 1. CRUD
-- CRUD 문제는 1. CRUD/00_setup_sample_data.sql에서 만든 students 테이블을 사용합니다.

-- 문제 1-1 정답: 수강생 추가
-- INSERT: 실습용 학생 한 명을 추가하고, RETURNING으로 추가된 행을 바로 확인합니다.
INSERT INTO students (name, email, birth_date, phone)
VALUES ('실습학생', 'practice@example.com', '2001-01-01', NULL)
RETURNING student_id, name, email;

-- 문제 1-2 정답: 추가한 수강생의 전화번호 수정
-- UPDATE: 방금 추가한 학생만 바꾸기 위해 email을 조건으로 사용합니다.
UPDATE students
SET phone = '010-9999-9999'
WHERE email = 'practice@example.com'
RETURNING student_id, name, phone;

-- 문제 1-3 정답: 추가한 수강생 조회
-- SELECT: 수정 결과를 이메일 조건으로 확인합니다.
SELECT
    student_id,
    name,
    email,
    phone
FROM students
WHERE email = 'practice@example.com';

-- 문제 1-4 정답: 추가한 수강생 삭제
-- DELETE: 실습 데이터가 남지 않도록 삭제하고, RETURNING으로 삭제된 행을 확인합니다.
DELETE FROM students
WHERE email = 'practice@example.com'
RETURNING student_id, name, email;

-- 문제 2. 조건 조회
-- DQL 문제는 restore.sql로 만든 영화 대여점 샘플 테이블을 사용합니다.

-- 문제 2-1 정답: 대여료가 4.99 이상인 영화 조회
-- 가격 조건 조회: rental_rate가 4.99 이상인 영화만 남깁니다.
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate >= 4.99
ORDER BY rental_rate DESC, title;

-- 문제 2-2 정답: PG 또는 PG-13 등급 영화 조회
-- IN 조건 조회: 두 등급 중 하나에 속하면 조회됩니다.
SELECT
    title,
    rating
FROM film
WHERE rating IN ('PG', 'PG-13')
ORDER BY rating, title;

-- 문제 2-3 정답: 길이가 60분에서 90분 사이인 영화 조회
-- BETWEEN 조건 조회: 60 이상 90 이하 범위의 영화 길이를 찾습니다.
SELECT
    title,
    length
FROM film
WHERE length BETWEEN 60 AND 90
ORDER BY length, title;

-- 문제 2-4 정답: 이름이 ann으로 시작하는 고객 조회
-- ILIKE 조건 조회: 대소문자를 구분하지 않고 ann으로 시작하는 이름을 찾습니다.
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE first_name ILIKE 'ann%'
ORDER BY first_name, last_name;

-- 문제 3. 집계
-- 문제 3-1 정답: 등급별 영화 수 조회
-- GROUP BY: rating별로 행을 묶고 COUNT로 개수를 셉니다.
SELECT
    rating,
    COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC, rating;

-- 문제 3-2 정답: 등급별 평균 영화 길이 조회
-- AVG: 등급별 평균 영화 길이를 계산하고 ROUND로 소수 둘째 자리까지 표시합니다.
SELECT
    rating,
    ROUND(AVG(length), 2) AS average_length
FROM film
WHERE length IS NOT NULL
GROUP BY rating
ORDER BY average_length DESC;

-- 문제 3-3 정답: 고객별 총 결제 금액 조회
-- SUM: 고객별 결제 금액 합계를 계산합니다.
SELECT
    customer_id,
    SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC;

-- 문제 3-4 정답: 대여 횟수가 30건 이상인 고객 조회
-- HAVING: 대여 횟수를 집계한 뒤 30건 이상인 고객만 남깁니다.
SELECT
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY rental_count DESC, customer_id;

-- 문제 4. 조인
-- 문제 4-1 정답: 대여번호, 고객명, 영화 제목, 대여일 조회
-- 대여 정보를 고객, 재고, 영화 테이블과 연결합니다.
SELECT
    r.rental_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title AS film_title,
    r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.rental_date DESC;

-- 문제 4-2 정답: 결제번호, 고객명, 직원명, 결제 금액, 결제일 조회
-- 결제 정보를 고객과 직원 테이블에 연결해 사람이 읽기 쉬운 이름으로 표시합니다.
SELECT
    p.payment_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    s.first_name || ' ' || s.last_name AS staff_name,
    p.amount,
    p.payment_date
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN staff s ON p.staff_id = s.staff_id
ORDER BY p.payment_date DESC;

-- 문제 4-3 정답: 카테고리별 영화 수 조회
-- LEFT JOIN으로 영화가 없는 카테고리도 결과에 남길 수 있습니다.
SELECT
    c.name AS category_name,
    COUNT(f.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC, category_name;

-- 문제 4-4 정답: 고객명, 주소, 도시, 국가 조회
-- 고객 주소를 address -> city -> country 순서로 연결합니다.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    a.address,
    ci.city,
    co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY c.customer_id;

-- 문제 5. 서브쿼리와 CTE
-- 문제 5-1 정답: 평균 대여료보다 비싼 영화 조회
-- 평균 대여료는 서브쿼리에서 먼저 계산됩니다.
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
)
ORDER BY rental_rate DESC, title;

-- 문제 5-2 정답: Action 카테고리에 속한 영화를 서브쿼리로 조회
-- Action 카테고리의 film_id 목록을 서브쿼리에서 만들고, 바깥 쿼리에서 영화 정보를 조회합니다.
SELECT
    title,
    rating,
    rental_rate
FROM film
WHERE film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
)
ORDER BY title;

-- 문제 5-3 정답: 결제 기록이 있는 대여를 EXISTS로 조회
-- EXISTS는 결제 기록이 하나라도 존재하는 대여만 조회합니다.
SELECT
    rental_id,
    customer_id,
    rental_date,
    return_date
FROM rental r
WHERE EXISTS (
    SELECT 1
    FROM payment p
    WHERE p.rental_id = r.rental_id
)
ORDER BY rental_date DESC;

-- 문제 5-4 정답: CTE로 고객별 대여 수 계산 후 30건 이상인 고객 조회
-- CTE로 고객별 대여 수를 먼저 만들고, 최종 SELECT에서 조건을 적용합니다.
WITH customer_rental_stats AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(r.rental_id) AS rental_count
    FROM customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    rental_count
FROM customer_rental_stats
WHERE rental_count >= 30
ORDER BY rental_count DESC, customer_name;
