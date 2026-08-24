-- PostgreSQL DDL 기초 03
-- 테이블 관계: 1:N, N:M, FOREIGN KEY

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE
);

COMMENT ON TABLE students IS '수강생 기본 정보';
COMMENT ON COLUMN students.student_id IS '수강생을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN students.name IS '수강생 이름';
COMMENT ON COLUMN students.email IS '수강생 이메일, 중복 불가';

CREATE TABLE courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

COMMENT ON TABLE courses IS '강의 기본 정보';
COMMENT ON COLUMN courses.course_id IS '강의를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN courses.title IS '강의명';
COMMENT ON COLUMN courses.price IS '강의 가격, 0 이상만 허용';

-- students와 courses는 N:M 관계입니다.
-- 중간 테이블 enrollments를 만들어 1:N + 1:N 구조로 분리합니다.
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

-- enrollments와 payments는 1:N 관계입니다.
-- 하나의 수강 신청에 여러 결제 기록이 생길 수 있습니다.
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

INSERT INTO students (name, email)
VALUES
    ('김민준', 'minjun@example.com'),
    ('이서연', 'seoyeon@example.com'),
    ('박도윤', 'doyun@example.com');

INSERT INTO courses (title, price)
VALUES
    ('SQL 기초', 120000),
    ('Python 기초', 100000);

INSERT INTO enrollments (student_id, course_id, status, score)
VALUES
    (1, 1, 'completed', 92.5),
    (1, 2, 'enrolled', NULL),
    (2, 1, 'completed', 85.0);

INSERT INTO payments (enrollment_id, amount, method)
VALUES
    (1, 120000, 'card'),
    (2, 100000, 'bank_transfer'),
    (3, 120000, 'card');

SELECT
    s.name AS student_name,
    c.title AS course_title,
    e.status,
    e.score,
    p.amount,
    p.method
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
ORDER BY s.name, c.title;

-- 외래키 오류 확인: 존재하지 않는 student_id를 참조합니다.
-- INSERT INTO enrollments (student_id, course_id) VALUES (999, 1);
