
-- 문제 1 정답: 데이터베이스 생성
-- IF NOT EXISTS를 사용하면 같은 데이터베이스가 있어도 오류 없이 넘어갑니다.
CREATE DATABASE  IF NOT EXISTS online_shop;

-- 이 아래 SQL은 online_shop 데이터베이스에서 실행됩니다.
USE online_shop;


-- 문제 2 정답: 테이블 생성
-- 같은 이름의 테이블이 있으면 새로 만들 수 없으므로 먼저 삭제합니다.
DROP TABLE IF EXISTS users;

-- users 테이블은 쇼핑몰 회원 정보를 저장합니다.
CREATE TABLE users (
    -- AUTO_INCREMENT는 새 행이 들어올 때마다 번호를 자동으로 증가시킵니다.
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    -- UNIQUE는 같은 username이나 email이 중복 저장되지 않도록 막습니다.
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    -- 실제 서비스에서는 비밀번호 원문이 아니라 해시 값을 저장합니다.
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
