-- PostgreSQL DDL 기초 02
-- 제약조건: NOT NULL, UNIQUE, CHECK, DEFAULT, PRIMARY KEY

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    birth_date DATE,
    phone VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE students IS '수강생 기본 정보';
COMMENT ON COLUMN students.student_id IS '수강생을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN students.name IS '수강생 이름';
COMMENT ON COLUMN students.email IS '수강생 이메일, 중복 불가';
COMMENT ON COLUMN students.birth_date IS '수강생 생년월일';
COMMENT ON COLUMN students.phone IS '수강생 전화번호';
COMMENT ON COLUMN students.created_at IS '수강생 등록 시각';

CREATE TABLE courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL,
    price NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (price >= 0),
    level VARCHAR(20) NOT NULL CHECK (
        level IN ('beginner', 'intermediate', 'advanced')
    ),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    opened_on DATE
);

COMMENT ON TABLE courses IS '강의 기본 정보';
COMMENT ON COLUMN courses.course_id IS '강의를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN courses.title IS '강의명';
COMMENT ON COLUMN courses.category IS '강의 카테고리';
COMMENT ON COLUMN courses.price IS '강의 가격, 0 이상만 허용';
COMMENT ON COLUMN courses.level IS '강의 난이도';
COMMENT ON COLUMN courses.is_active IS '강의 활성 상태';
COMMENT ON COLUMN courses.opened_on IS '강의 개강일';

INSERT INTO students (name, email, birth_date, phone)
VALUES
    ('김민준', 'minjun@example.com', '2001-03-12', '010-1111-1111'),
    ('이서연', 'seoyeon@example.com', '2000-07-22', '010-2222-2222');

INSERT INTO courses (title, category, price, level, opened_on)
VALUES
    ('SQL 기초', 'database', 120000, 'beginner', '2026-07-01'),
    ('Python 기초', 'programming', 100000, 'beginner', '2026-07-08');

SELECT *
FROM students;

SELECT *
FROM courses;

-- 아래 문장들은 제약조건 오류를 확인할 때 주석을 풀고 하나씩 실행합니다.

-- NOT NULL 위반
-- INSERT INTO students (email) VALUES ('noname@example.com');

-- UNIQUE 위반
-- INSERT INTO students (name, email) VALUES ('중복학생', 'minjun@example.com');

-- CHECK 위반: price는 0 이상이어야 합니다.
-- INSERT INTO courses (title, category, price, level)
-- VALUES ('잘못된 강의', 'database', -1000, 'beginner');

-- CHECK 위반: level은 지정된 값 중 하나여야 합니다.
-- INSERT INTO courses (title, category, price, level)
-- VALUES ('알 수 없는 난이도', 'database', 10000, 'starter');
