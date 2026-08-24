-- 문제 3 정답: 아래 ERD를 참고하여 테이블을 생성하세요.

-- 데이터베이스 생성
CREATE DATABASE  IF NOT EXISTS online_shop;

-- 이 아래 SQL은 online_shop 데이터베이스에서 실행됩니다.
USE online_shop;

-- 외래키가 있는 테이블은 자식 테이블부터 삭제해야 재실행 시 오류가 줄어듭니다.
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- users: 쇼핑몰 회원 정보를 저장하는 부모 테이블입니다.
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- products: 판매 상품 정보를 저장합니다.
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- orders: 한 회원이 만든 주문 한 건을 저장합니다.
-- user_id는 users.user_id를 참조하여 "누가 주문했는지" 연결합니다.
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- order_items: 주문에 담긴 개별 상품 목록입니다.
-- 주문 1건에 여러 상품이 들어갈 수 있으므로 orders와 products를 함께 참조합니다.
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
