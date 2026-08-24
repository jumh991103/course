-- PostgreSQL DQL 기초 04
-- 서브쿼리와 CTE

-- restore.sql을 실행해 만든 영화 대여점 샘플 테이블에서 실행합니다.

-- 평균 대여료보다 비싼 영화
SELECT
    title,
    rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
)
ORDER BY rental_rate DESC, title;

-- Action 카테고리에 속한 영화
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

-- 결제 기록이 있는 대여
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
ORDER BY rental_date DESC
LIMIT 20;

-- CTE로 고객별 대여 수를 먼저 계산한 뒤 조회
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

-- CTE 여러 단계 사용
WITH category_payments AS (
    SELECT
        cat.name AS category_name,
        p.amount
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
),
category_sales AS (
    SELECT
        category_name,
        COUNT(*) AS payment_count,
        SUM(amount) AS total_sales
    FROM category_payments
    GROUP BY category_name
)
SELECT
    category_name,
    payment_count,
    total_sales
FROM category_sales
ORDER BY total_sales DESC;
