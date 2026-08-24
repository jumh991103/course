-- PostgreSQL DQL 기초 01
-- 조건 조회: WHERE, ORDER BY, LIMIT

-- restore.sql을 실행해 만든 영화 대여점 샘플 테이블에서 실행합니다.

-- 영화 목록 확인
SELECT
    film_id,
    title,
    rental_rate,
    length,
    rating
FROM film
ORDER BY film_id
LIMIT 10;

-- 필요한 컬럼만 선택하기
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    activebool
FROM customer
ORDER BY customer_id
LIMIT 10;

-- 비교 조건: 대여료가 4.99 이상인 영화
SELECT
    film_id,
    title,
    rental_rate,
    replacement_cost
FROM film
WHERE rental_rate >= 4.99
ORDER BY rental_rate DESC, title
LIMIT 20;

-- AND, OR 조건: 긴 영화이거나 등급이 PG-13인 영화
SELECT
    film_id,
    title,
    length,
    rating
FROM film
WHERE length >= 180
   OR rating = 'PG-13'
ORDER BY length DESC NULLS LAST
LIMIT 20;

-- IN 조건: 특정 등급의 영화
SELECT
    title,
    rating
FROM film
WHERE rating IN ('G', 'PG', 'PG-13')
ORDER BY rating, title
LIMIT 20;

-- BETWEEN 조건: 60분에서 90분 사이 영화
SELECT
    title,
    length
FROM film
WHERE length BETWEEN 60 AND 90
ORDER BY length, title
LIMIT 20;

-- 문자열 패턴 검색: 제목에 AIR가 들어간 영화
SELECT
    title,
    description
FROM film
WHERE title LIKE '%AIR%'
ORDER BY title;

-- 대소문자 구분 없는 패턴 검색: 이름이 ann으로 시작하는 고객
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE first_name ILIKE 'ann%'
ORDER BY first_name, last_name;

-- NULL 조회
SELECT
    address_id,
    address,
    address2
FROM address
WHERE address2 IS NULL
ORDER BY address_id
LIMIT 20;

-- LIMIT으로 일부만 조회
SELECT
    payment_id,
    customer_id,
    amount,
    payment_date
FROM payment
ORDER BY amount DESC, payment_date
LIMIT 10;
