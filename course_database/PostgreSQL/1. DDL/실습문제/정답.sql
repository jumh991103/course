-- PostgreSQL DDL 기초 실습문제 정답
-- 실행 순서: 기존 테이블 삭제 -> 새 테이블 생성 -> 테이블/컬럼 주석 작성 -> 샘플 데이터 입력 -> 결과 확인 -> 오류 예시 확인

-- 공통 준비: 정답을 여러 번 실행해도 같은 상태에서 시작하도록 기존 테이블을 정리합니다.
-- 외래키 관계가 있으므로 자식 테이블(practice_enrollments)을 먼저 삭제합니다.
DROP TABLE IF EXISTS practice_enrollments;
DROP TABLE IF EXISTS practice_courses;
DROP TABLE IF EXISTS practice_students;

-- ###############################################
-- 문제 1 정답: 수강생 테이블 만들기
-- ###############################################
-- 수강생 테이블: 자동 증가 기본키, 필수값, 이메일 중복 방지, 기본 생성 시각을 확인하는 예제입니다.
CREATE TABLE practice_students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    birth_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ###############################################
-- 문제 4 정답: 수강생 테이블과 컬럼 주석 작성하기
-- ###############################################
-- PostgreSQL은 MySQL의 COMMENT 옵션 대신 COMMENT ON 문으로 주석을 따로 작성합니다.
COMMENT ON TABLE practice_students IS 'DDL 실습용 수강생 정보';
COMMENT ON COLUMN practice_students.student_id IS '수강생을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_students.name IS '수강생 이름';
COMMENT ON COLUMN practice_students.email IS '수강생 이메일, 중복 불가';
COMMENT ON COLUMN practice_students.birth_date IS '수강생 생년월일';
COMMENT ON COLUMN practice_students.created_at IS '수강생 등록 시각';

-- ###############################################
-- 문제 2 정답: 강의 테이블 만들기
-- ###############################################
-- 강의 테이블: CHECK 제약조건으로 가격과 난이도에 들어갈 수 있는 값을 제한합니다.
CREATE TABLE practice_courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    level VARCHAR(20) NOT NULL CHECK (
        level IN ('beginner', 'intermediate', 'advanced')
    ),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- ###############################################
-- 문제 4 정답: 강의 테이블과 컬럼 주석 작성하기
-- ###############################################
COMMENT ON TABLE practice_courses IS 'DDL 실습용 강의 정보';
COMMENT ON COLUMN practice_courses.course_id IS '강의를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_courses.title IS '강의명';
COMMENT ON COLUMN practice_courses.price IS '강의 가격, 0 이상만 허용';
COMMENT ON COLUMN practice_courses.level IS '강의 난이도';
COMMENT ON COLUMN practice_courses.is_active IS '강의 활성 상태';

-- ###############################################
-- 문제 3 정답: 수강 신청 테이블 만들기
-- ###############################################
-- 수강 신청 테이블: 수강생과 강의를 연결하는 N:M 관계 테이블입니다.
-- UNIQUE (student_id, course_id)는 같은 수강생이 같은 강의를 중복 신청하지 못하게 막습니다.
CREATE TABLE practice_enrollments (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES practice_students(student_id),
    course_id INTEGER NOT NULL REFERENCES practice_courses(course_id),
    enrolled_at DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (student_id, course_id)
);

-- ###############################################
-- 문제 4 정답: 수강 신청 테이블과 컬럼 주석 작성하기
-- ###############################################
COMMENT ON TABLE practice_enrollments IS 'DDL 실습용 수강 신청 정보';
COMMENT ON COLUMN practice_enrollments.enrollment_id IS '수강 신청을 식별하는 자동 증가 기본키';
COMMENT ON COLUMN practice_enrollments.student_id IS '수강 신청한 수강생 ID';
COMMENT ON COLUMN practice_enrollments.course_id IS '신청한 강의 ID';
COMMENT ON COLUMN practice_enrollments.enrolled_at IS '수강 신청일';

-- 결과 확인용 샘플 데이터 입력
-- 테이블 관계를 확인할 수 있도록 수강생, 강의, 수강 신청 데이터를 차례대로 넣습니다.
INSERT INTO practice_students (name, email, birth_date)
VALUES
    ('김민준', 'minjun.practice@example.com', '2001-03-12'),
    ('이서연', 'seoyeon.practice@example.com', '2000-07-22');

INSERT INTO practice_courses (title, price, level)
VALUES
    ('SQL 기초', 120000, 'beginner'),
    ('Python 기초', 100000, 'beginner');

INSERT INTO practice_enrollments (student_id, course_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 1);

-- 결과 확인: 문제 1에서 만든 수강생 테이블의 데이터와 구조를 확인합니다.
SELECT *
FROM practice_students;

-- 결과 확인: 문제 2에서 만든 강의 테이블의 데이터와 구조를 확인합니다.
SELECT *
FROM practice_courses;

-- 결과 확인: 문제 3에서 만든 수강 신청 테이블의 데이터와 관계를 확인합니다.
SELECT *
FROM practice_enrollments;

-- ###############################################
-- 문제 5 정답: 제약조건 오류 확인하기
-- ###############################################
-- 아래 SQL은 일부러 오류가 나도록 만든 예시입니다. 하나씩 주석을 풀고 실행합니다.

-- 문제 5-1 정답: 이름이 없는 수강생 입력은 name NOT NULL 제약조건 때문에 실패합니다.
-- INSERT INTO practice_students (email) VALUES ('noname.practice@example.com');

-- 문제 5-2 정답: 같은 이메일 입력은 email UNIQUE 제약조건 때문에 실패합니다.
-- INSERT INTO practice_students (name, email) VALUES ('중복', 'minjun.practice@example.com');

-- 문제 5-3 정답: 음수 가격 입력은 price CHECK (price >= 0) 제약조건 때문에 실패합니다.
-- INSERT INTO practice_courses (title, price, level) VALUES ('오류 강의', -1, 'beginner');

-- 문제 5-4 정답: 존재하지 않는 수강생 번호는 외래키 제약조건 때문에 실패합니다.
-- INSERT INTO practice_enrollments (student_id, course_id) VALUES (999, 1);
