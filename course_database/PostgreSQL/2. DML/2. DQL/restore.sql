-- PostgreSQL DQL sample restore script
-- Run this file in the database connection you want to use for class practice.
-- It is intentionally self-contained so it works in DBeaver and psql without
-- external .dat files, psql meta commands, or OS-specific locale settings.

BEGIN;

SET client_encoding = 'UTF8';
SET search_path = public;

DROP VIEW IF EXISTS
    public.actor_info,
    public.customer_list,
    public.film_list,
    public.nicer_but_slower_film_list,
    public.sales_by_film_category,
    public.sales_by_store,
    public.staff_list
CASCADE;

DROP TABLE IF EXISTS
    public.payment,
    public.rental,
    public.inventory,
    public.film_category,
    public.film_actor,
    public.store,
    public.staff,
    public.customer,
    public.address,
    public.city,
    public.country,
    public.film,
    public.category,
    public.actor,
    public.language
CASCADE;

DROP TYPE IF EXISTS public.mpaa_rating CASCADE;
DROP DOMAIN IF EXISTS public.year CASCADE;

CREATE TYPE public.mpaa_rating AS ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17');

CREATE TABLE public.language (
    language_id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.actor (
    actor_id INTEGER PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.category (
    category_id INTEGER PRIMARY KEY,
    name VARCHAR(25) NOT NULL UNIQUE,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.country (
    country_id INTEGER PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.city (
    city_id INTEGER PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INTEGER NOT NULL REFERENCES public.country(country_id),
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.address (
    address_id INTEGER PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    address2 VARCHAR(100),
    district VARCHAR(50) NOT NULL,
    city_id INTEGER NOT NULL REFERENCES public.city(city_id),
    postal_code VARCHAR(20),
    phone VARCHAR(30),
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.customer (
    customer_id INTEGER PRIMARY KEY,
    store_id INTEGER NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address_id INTEGER NOT NULL REFERENCES public.address(address_id),
    activebool BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATE NOT NULL DEFAULT CURRENT_DATE,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE public.staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address_id INTEGER NOT NULL REFERENCES public.address(address_id),
    email VARCHAR(100),
    store_id INTEGER NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(40),
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    picture BYTEA
);

CREATE TABLE public.store (
    store_id INTEGER PRIMARY KEY,
    manager_staff_id INTEGER NOT NULL REFERENCES public.staff(staff_id),
    address_id INTEGER NOT NULL REFERENCES public.address(address_id),
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.film (
    film_id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INTEGER,
    language_id INTEGER NOT NULL REFERENCES public.language(language_id),
    rental_duration INTEGER NOT NULL,
    rental_rate NUMERIC(4, 2) NOT NULL,
    length INTEGER,
    replacement_cost NUMERIC(5, 2) NOT NULL,
    rating public.mpaa_rating NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    special_features TEXT[],
    fulltext TEXT
);

CREATE TABLE public.film_actor (
    actor_id INTEGER NOT NULL REFERENCES public.actor(actor_id),
    film_id INTEGER NOT NULL REFERENCES public.film(film_id),
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (actor_id, film_id)
);

CREATE TABLE public.film_category (
    film_id INTEGER NOT NULL REFERENCES public.film(film_id),
    category_id INTEGER NOT NULL REFERENCES public.category(category_id),
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (film_id, category_id)
);

CREATE TABLE public.inventory (
    inventory_id INTEGER PRIMARY KEY,
    film_id INTEGER NOT NULL REFERENCES public.film(film_id),
    store_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.rental (
    rental_id INTEGER PRIMARY KEY,
    rental_date TIMESTAMP NOT NULL,
    inventory_id INTEGER NOT NULL REFERENCES public.inventory(inventory_id),
    customer_id INTEGER NOT NULL REFERENCES public.customer(customer_id),
    return_date TIMESTAMP,
    staff_id INTEGER NOT NULL REFERENCES public.staff(staff_id),
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE public.payment (
    payment_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES public.customer(customer_id),
    staff_id INTEGER NOT NULL REFERENCES public.staff(staff_id),
    rental_id INTEGER NOT NULL REFERENCES public.rental(rental_id),
    amount NUMERIC(5, 2) NOT NULL,
    payment_date TIMESTAMP NOT NULL
);

INSERT INTO public.language (language_id, name)
VALUES
    (1, 'English');

INSERT INTO public.actor (actor_id, first_name, last_name)
VALUES
    (1, 'Penelope', 'Guiness'),
    (2, 'Nick', 'Wahlberg'),
    (3, 'Ed', 'Chase'),
    (4, 'Jennifer', 'Davis'),
    (5, 'Johnny', 'Lollobrigida'),
    (6, 'Bette', 'Nicholson'),
    (7, 'Grace', 'Mostel'),
    (8, 'Matthew', 'Johansson');

INSERT INTO public.category (category_id, name)
VALUES
    (1, 'Action'),
    (2, 'Comedy'),
    (3, 'Drama'),
    (4, 'Family'),
    (5, 'Documentary'),
    (6, 'Horror');

INSERT INTO public.country (country_id, country)
VALUES
    (1, 'South Korea'),
    (2, 'United States'),
    (3, 'Canada'),
    (4, 'Japan');

INSERT INTO public.city (city_id, city, country_id)
VALUES
    (1, 'Seoul', 1),
    (2, 'Busan', 1),
    (3, 'New York', 2),
    (4, 'Toronto', 3),
    (5, 'Tokyo', 4);

INSERT INTO public.address (address_id, address, address2, district, city_id, postal_code, phone)
VALUES
    (1, '11 Teheran-ro', NULL, 'Gangnam', 1, '06134', '010-1000-0001'),
    (2, '22 Haeundae-ro', 'Suite 2', 'Haeundae', 2, '48095', '010-1000-0002'),
    (3, '33 Broadway', NULL, 'Manhattan', 3, '10001', '010-1000-0003'),
    (4, '44 Queen Street', NULL, 'Downtown', 4, 'M5H', '010-1000-0004'),
    (5, '55 Shibuya Crossing', 'Floor 5', 'Shibuya', 5, '150-0002', '010-1000-0005'),
    (6, '66 Jongno', NULL, 'Jongno', 1, '03154', '010-1000-0006'),
    (7, '77 Centum Road', NULL, 'Centum', 2, '48060', '010-1000-0007'),
    (8, '88 Madison Avenue', NULL, 'Midtown', 3, '10010', '010-1000-0008');

INSERT INTO public.customer (customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, active)
VALUES
    (1, 1, 'Ann', 'Kim', 'ann.kim@example.com', 1, TRUE, '2024-01-01', 1),
    (2, 1, 'Anna', 'Lee', 'anna.lee@example.com', 2, TRUE, '2024-01-02', 1),
    (3, 1, 'Brian', 'Park', 'brian.park@example.com', 3, TRUE, '2024-01-03', 1),
    (4, 2, 'Chloe', 'Jung', 'chloe.jung@example.com', 4, TRUE, '2024-01-04', 1),
    (5, 2, 'Daniel', 'Choi', 'daniel.choi@example.com', 5, FALSE, '2024-01-05', 0),
    (6, 2, 'Emma', 'Han', 'emma.han@example.com', 6, TRUE, '2024-01-06', 1),
    (7, 1, 'Min', 'Seo', 'min.seo@example.com', 7, TRUE, '2024-01-07', 1),
    (8, 2, 'Sofia', 'Moon', 'sofia.moon@example.com', 8, TRUE, '2024-01-08', 1);

INSERT INTO public.staff (staff_id, first_name, last_name, address_id, email, store_id, username)
VALUES
    (1, 'Mike', 'Hillyer', 1, 'mike@example.com', 1, 'Mike'),
    (2, 'Jon', 'Stephens', 2, 'jon@example.com', 2, 'Jon');

INSERT INTO public.store (store_id, manager_staff_id, address_id)
VALUES
    (1, 1, 1),
    (2, 2, 2);

INSERT INTO public.film (
    film_id,
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating,
    special_features,
    fulltext
)
VALUES
    (1, 'ACADEMY DINOSAUR', 'A drama about a dinosaur and a teacher.', 2006, 1, 6, 0.99, 86, 20.99, 'PG', ARRAY['Deleted Scenes'], 'academy dinosaur drama'),
    (2, 'ACTION HEROES', 'A fast action story with a brave team.', 2006, 1, 3, 4.99, 120, 22.99, 'PG-13', ARRAY['Trailers'], 'action heroes'),
    (3, 'AIRPORT POLLOCK', 'A documentary filmed around a busy AIR terminal.', 2006, 1, 6, 4.99, 54, 15.99, 'R', ARRAY['Commentaries'], 'airport pollock air'),
    (4, 'AIR FORCE DREAM', 'A family adventure above the clouds.', 2006, 1, 5, 2.99, 90, 18.99, 'PG', ARRAY['Trailers'], 'air force dream'),
    (5, 'BEACH HEART', 'A comedy set on a summer beach.', 2006, 1, 4, 2.99, 75, 12.99, 'G', ARRAY['Behind the Scenes'], 'beach heart'),
    (6, 'CITY RUNNER', 'A long chase across a city.', 2006, 1, 7, 4.99, 185, 25.99, 'PG-13', ARRAY['Trailers'], 'city runner'),
    (7, 'DARK FOREST', 'A horror story in a dark forest.', 2006, 1, 3, 3.99, 110, 21.99, 'R', ARRAY['Deleted Scenes'], 'dark forest'),
    (8, 'FAMILY PARK', 'A warm family story.', 2006, 1, 5, 0.99, 68, 14.99, 'G', ARRAY['Trailers'], 'family park'),
    (9, 'GLOBAL CODE', 'A documentary about software teams.', 2006, 1, 4, 2.99, 92, 16.99, 'PG', ARRAY['Commentaries'], 'global code'),
    (10, 'HIDDEN PLAN', 'An action film about a secret plan.', 2006, 1, 6, 4.99, 144, 24.99, 'PG-13', ARRAY['Trailers'], 'hidden plan'),
    (11, 'ISLAND LAUGH', 'A light comedy on an island.', 2006, 1, 3, 0.99, 64, 10.99, 'PG', ARRAY['Deleted Scenes'], 'island laugh'),
    (12, 'JOURNEY NORTH', 'A drama about a long journey.', 2006, 1, 5, 2.99, 135, 19.99, 'PG-13', ARRAY['Trailers'], 'journey north');

INSERT INTO public.film_actor (actor_id, film_id)
VALUES
    (1, 1), (2, 1), (3, 1),
    (2, 2), (4, 2),
    (5, 3), (6, 3),
    (1, 4), (7, 4),
    (3, 5), (8, 5),
    (4, 6), (6, 6),
    (5, 7), (7, 7),
    (1, 8), (8, 8),
    (2, 9), (3, 9),
    (4, 10), (5, 10),
    (6, 11), (7, 11),
    (2, 12), (8, 12);

INSERT INTO public.film_category (film_id, category_id)
VALUES
    (1, 3),
    (2, 1),
    (3, 5),
    (4, 4),
    (5, 2),
    (6, 1),
    (7, 6),
    (8, 4),
    (9, 5),
    (10, 1),
    (11, 2),
    (12, 3);

INSERT INTO public.inventory (inventory_id, film_id, store_id)
SELECT
    gs AS inventory_id,
    ((gs - 1) % 12) + 1 AS film_id,
    CASE WHEN gs % 2 = 0 THEN 2 ELSE 1 END AS store_id
FROM generate_series(1, 36) AS gs;

INSERT INTO public.rental (
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id
)
SELECT
    gs AS rental_id,
    timestamp '2024-01-01 10:00:00' + (gs * interval '1 day') AS rental_date,
    ((gs - 1) % 36) + 1 AS inventory_id,
    CASE
        WHEN gs <= 35 THEN 1
        ELSE ((gs - 36) % 7) + 2
    END AS customer_id,
    timestamp '2024-01-03 10:00:00' + (gs * interval '1 day') AS return_date,
    CASE WHEN gs % 2 = 0 THEN 2 ELSE 1 END AS staff_id
FROM generate_series(1, 60) AS gs;

INSERT INTO public.payment (
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
SELECT
    rental_id AS payment_id,
    customer_id,
    staff_id,
    rental_id,
    (1.99 + ((rental_id % 5) * 1.00))::NUMERIC(5, 2) AS amount,
    rental_date + interval '1 hour' AS payment_date
FROM public.rental;

COMMIT;
