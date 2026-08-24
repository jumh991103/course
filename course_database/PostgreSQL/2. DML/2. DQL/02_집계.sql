-- PostgreSQL DQL 기초 02
-- 집계: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING

-- restore.sql을 실행해 만든 영화 대여점 샘플 테이블에서 실행합니다.

-- 전체 영화 수
SELECT COUNT(*) AS film_count
FROM film;

-- 등급별 영화 수
SELECT
    rating,
    COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC, rating;

-- 등급별 영화 길이 통계
SELECT
    rating,
    COUNT(*) AS film_count,
    ROUND(AVG(length), 2) AS average_length,
    MIN(length) AS min_length,
    MAX(length) AS max_length
FROM film
WHERE length IS NOT NULL
GROUP BY rating
ORDER BY average_length DESC;

-- 고객별 결제 금액
SELECT
    customer_id,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 20;

-- HAVING: 집계 결과에 조건 적용
SELECT
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 30
ORDER BY rental_count DESC, customer_id;

-- 월별 매출
SELECT
    DATE_TRUNC('month', payment_date)::date AS payment_month,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_amount
FROM payment
GROUP BY DATE_TRUNC('month', payment_date)::date
ORDER BY payment_month;
