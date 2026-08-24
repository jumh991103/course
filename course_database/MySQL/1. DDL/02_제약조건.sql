-- ###############################################
-- MySQL DDL 기초 02
-- 제약조건: NOT NULL, UNIQUE, CHECK, DEFAULT, PRIMARY KEY
-- 제약조건은 잘못된 데이터가 테이블에 들어가지 않도록 막아 주는 규칙입니다.
-- ###############################################
CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

-- 이전 실습 결과가 남아 있어도 같은 결과가 나오도록 테이블을 초기화합니다.
-- 외래키가 있는 테이블은 참조하는 테이블보다 먼저 삭제해야 합니다.
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

-- students 테이블: PRIMARY KEY, NOT NULL, UNIQUE, DEFAULT를 확인합니다.
CREATE TABLE students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    birth_date DATE COMMENT '수강생 생년월일',
    phone VARCHAR(20) COMMENT '수강생 전화번호',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수강생 등록 시각',
    PRIMARY KEY (student_id)
) COMMENT = '수강생 기본 정보';

-- courses 테이블: CHECK와 ENUM으로 허용되는 값을 제한합니다.
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    category VARCHAR(30) NOT NULL COMMENT '강의 카테고리',
    price DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (price >= 0) COMMENT '강의 가격, 0 이상만 허용',
    level ENUM('beginner', 'intermediate', 'advanced') NOT NULL COMMENT '강의 난이도',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '강의 활성 상태',
    opened_on DATE COMMENT '강의 개강일',
    PRIMARY KEY (course_id)
) COMMENT = '강의 기본 정보';

-- ###############################################
-- 제약조건 검증 
-- ###############################################
-- 제약조건을 만족하는 정상 데이터를 먼저 넣어 봅니다.
INSERT INTO students (name, email, birth_date, phone)
VALUES
    ('김민준', 'minjun@example.com', '2001-03-12', '010-1111-1111'),
    ('이서연', 'seoyeon@example.com', '2000-07-22', '010-2222-2222');

INSERT INTO courses (title, category, price, level, opened_on)
VALUES
    ('SQL 기초', 'database', 120000, 'beginner', '2026-07-01'),
    ('Python 기초', 'programming', 100000, 'beginner', '2026-07-08');

-- INSERT 결과를 확인합니다.
SELECT *
FROM students;

SELECT *
FROM courses;    

-- 아래 문장들은 제약조건 오류를 확인할 때 주석을 풀고 하나씩 실행합니다.
-- 오류 예시는 한 번에 여러 개를 풀지 말고, 하나씩 실행해야 원인을 확인하기 쉽습니다.

-- NOT NULL 위반
-- INSERT INTO students (email) VALUES ('noname@example.com');

-- UNIQUE 위반
-- INSERT INTO students (name, email) VALUES ('중복학생', 'minjun@example.com');

-- CHECK 위반: price는 0 이상이어야 합니다.
-- INSERT INTO courses (title, category, price, level)
-- VALUES ('잘못된 강의', 'database', -1000, 'beginner');
