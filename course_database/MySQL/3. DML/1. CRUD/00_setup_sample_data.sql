-- MySQL DML 실습용 샘플 데이터
-- DML 예제에서 공통으로 사용할 수강생, 강의, 수강 신청, 결제 데이터를 준비합니다.

CREATE DATABASE IF NOT EXISTS examplesdb
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE examplesdb;

-- 실습을 반복해도 같은 상태에서 시작할 수 있도록 기존 테이블을 삭제합니다.
-- 외래키 관계 때문에 자식 테이블(payments, enrollments)을 먼저 삭제합니다.
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

-- 수강생 기본 정보 테이블입니다.
CREATE TABLE students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    birth_date DATE COMMENT '수강생 생년월일',
    phone VARCHAR(20) COMMENT '수강생 전화번호',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수강생 등록 시각',
    PRIMARY KEY (student_id)
) COMMENT = '수강생 기본 정보';

-- 강의 기본 정보 테이블입니다.
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    category VARCHAR(30) NOT NULL COMMENT '강의 카테고리',
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0) COMMENT '강의 가격, 0 이상만 허용',
    level ENUM('beginner', 'intermediate', 'advanced') NOT NULL COMMENT '강의 난이도',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '강의 활성 상태',
    opened_on DATE COMMENT '강의 개강일',
    PRIMARY KEY (course_id)
) COMMENT = '강의 기본 정보';

-- 수강생과 강의는 N:M 관계이므로 enrollments 연결 테이블로 관리합니다.
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT COMMENT '수강 신청을 식별하는 자동 증가 기본키',
    student_id INT NOT NULL COMMENT '수강 신청한 수강생 ID',
    course_id INT NOT NULL COMMENT '신청한 강의 ID',
    enrolled_at DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '수강 신청일',
    status ENUM('enrolled', 'completed', 'canceled') NOT NULL DEFAULT 'enrolled' COMMENT '수강 신청 상태',
    score DECIMAL(5, 2) CHECK (score BETWEEN 0 AND 100) COMMENT '수료 또는 평가 점수',
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_enrollments_student_course (student_id, course_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE RESTRICT
) COMMENT = '수강생과 강의의 수강 신청 관계';

-- 결제는 특정 수강 신청(enrollment_id)에 연결됩니다.
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT COMMENT '결제 기록을 식별하는 자동 증가 기본키',
    enrollment_id INT NOT NULL COMMENT '결제 대상 수강 신청 ID',
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0) COMMENT '결제 금액',
    paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '결제 시각',
    method ENUM('card', 'bank_transfer', 'cash') NOT NULL COMMENT '결제 수단',
    PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_enrollment
        FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
) COMMENT = '수강 신청별 결제 기록';

-- 부모 테이블인 students, courses 데이터를 먼저 입력합니다.
INSERT INTO students (name, email, birth_date, phone)
VALUES
    ('김민준', 'minjun@example.com', '2001-03-12', '010-1111-1111'),
    ('이서연', 'seoyeon@example.com', '2000-07-22', '010-2222-2222'),
    ('박도윤', 'doyun@example.com', '1999-11-05', '010-3333-3333'),
    ('최하은', 'haeun@example.com', '2002-01-17', NULL),
    ('정지후', 'jihu@example.com', '1998-09-30', '010-5555-5555'),
    ('한지민', 'jimin@example.com', '2001-12-24', NULL);

INSERT INTO courses (title, category, price, level, is_active, opened_on)
VALUES
    ('SQL 기초', 'database', 120000, 'beginner', TRUE, '2026-07-01'),
    ('Python 기초', 'programming', 100000, 'beginner', TRUE, '2026-07-08'),
    ('데이터 분석 입문', 'data', 180000, 'intermediate', TRUE, '2026-08-01'),
    ('웹 백엔드 입문', 'web', 220000, 'intermediate', TRUE, '2026-08-15'),
    ('머신러닝 맛보기', 'ai', 250000, 'advanced', FALSE, '2026-09-01');

-- enrollments는 위에서 입력한 student_id와 course_id를 참조합니다.
INSERT INTO enrollments (student_id, course_id, enrolled_at, status, score)
VALUES
    (1, 1, '2026-07-01', 'completed', 92.5),
    (1, 2, '2026-07-08', 'enrolled', NULL),
    (2, 1, '2026-07-01', 'completed', 85.0),
    (2, 3, '2026-08-01', 'enrolled', NULL),
    (3, 1, '2026-07-03', 'completed', 78.0),
    (3, 4, '2026-08-16', 'enrolled', NULL),
    (4, 2, '2026-07-09', 'canceled', NULL),
    (5, 3, '2026-08-01', 'completed', 96.0),
    (5, 4, '2026-08-15', 'enrolled', NULL),
    (6, 1, '2026-07-04', 'completed', 88.0);

-- payments는 위에서 입력한 enrollment_id를 참조합니다.
INSERT INTO payments (enrollment_id, amount, paid_at, method)
VALUES
    (1, 120000, '2026-07-01 09:10:00', 'card'),
    (2, 100000, '2026-07-08 10:20:00', 'bank_transfer'),
    (3, 120000, '2026-07-01 11:30:00', 'card'),
    (4, 180000, '2026-08-01 12:40:00', 'cash'),
    (5, 120000, '2026-07-03 14:00:00', 'card'),
    (6, 220000, '2026-08-16 15:10:00', 'bank_transfer'),
    (8, 180000, '2026-08-01 16:20:00', 'card'),
    (9, 220000, '2026-08-15 17:30:00', 'card'),
    (10, 120000, '2026-07-04 18:40:00', 'cash');

-- MySQL Workbench 등에서 준비 완료 여부를 바로 확인하기 위한 메시지입니다.
SELECT 'sample data ready' AS message;
