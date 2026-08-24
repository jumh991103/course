-- PostgreSQL DQL 기초 03
-- 조인: INNER JOIN, LEFT JOIN

-- restore.sql을 실행해 만든 영화 대여점 샘플 테이블에서 실행합니다.

-- 대여 목록: 고객 + 대여 + 영화
SELECT
    r.rental_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title AS film_title,
    r.rental_date,
    r.return_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.rental_date DESC
LIMIT 20;

-- 결제 목록: 고객 + 직원 + 결제 정보
SELECT
    p.payment_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    s.first_name || ' ' || s.last_name AS staff_name,
    p.amount,
    p.payment_date
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN staff s ON p.staff_id = s.staff_id
ORDER BY p.payment_date DESC
LIMIT 20;

-- 영화별 배우 목록
SELECT
    f.title,
    a.first_name,
    a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title LIKE 'ACADEMY%'
ORDER BY f.title, a.last_name, a.first_name;

-- 카테고리별 영화 수: 영화가 없는 카테고리도 확인할 수 있도록 LEFT JOIN 사용
SELECT
    c.name AS category_name,
    COUNT(f.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC, category_name;

-- 고객 주소: customer -> address -> city -> country
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
ORDER BY c.customer_id
LIMIT 20;
