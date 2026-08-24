-- PostgreSQL DML/DQL 실습용 샘플 데이터

DROP TABLE IF EXISTS payments;
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
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
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

CREATE TABLE enrollments (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE RESTRICT,
    enrolled_at DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'enrolled' CHECK (
        status IN ('enrolled', 'completed', 'canceled')
    ),
    score NUMERIC(5, 2) CHECK (score BETWEEN 0 AND 100),
    UNIQUE (student_id, course_id)
);

COMMENT ON TABLE enrollments IS '수강생과 강의의 수강 신청 관계';
COMMENT ON COLUMN enrollments.enrollment_id IS '수강 신청을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN enrollments.student_id IS '수강 신청한 수강생 ID';
COMMENT ON COLUMN enrollments.course_id IS '신청한 강의 ID';
COMMENT ON COLUMN enrollments.enrolled_at IS '수강 신청일';
COMMENT ON COLUMN enrollments.status IS '수강 신청 상태';
COMMENT ON COLUMN enrollments.score IS '수료 또는 평가 점수';

CREATE TABLE payments (
    payment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    paid_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    method VARCHAR(20) NOT NULL CHECK (
        method IN ('card', 'bank_transfer', 'cash')
    )
);

COMMENT ON TABLE payments IS '수강 신청별 결제 기록';
COMMENT ON COLUMN payments.payment_id IS '결제 기록을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN payments.enrollment_id IS '결제 대상 수강 신청 ID';
COMMENT ON COLUMN payments.amount IS '결제 금액';
COMMENT ON COLUMN payments.paid_at IS '결제 시각';
COMMENT ON COLUMN payments.method IS '결제 수단';

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

INSERT INTO payments (enrollment_id, amount, paid_at, method)
VALUES
    (1, 120000, '2026-07-01 09:10:00+09', 'card'),
    (2, 100000, '2026-07-08 10:20:00+09', 'bank_transfer'),
    (3, 120000, '2026-07-01 11:30:00+09', 'card'),
    (4, 180000, '2026-08-01 12:40:00+09', 'cash'),
    (5, 120000, '2026-07-03 14:00:00+09', 'card'),
    (6, 220000, '2026-08-16 15:10:00+09', 'bank_transfer'),
    (8, 180000, '2026-08-01 16:20:00+09', 'card'),
    (9, 220000, '2026-08-15 17:30:00+09', 'card'),
    (10, 120000, '2026-07-04 18:40:00+09', 'cash');

SELECT 'sample data ready' AS message;
