-- PostgreSQL DDL 기초 01
-- 테이블 생성과 데이터 타입

DROP TABLE IF EXISTS datatype_examples;

CREATE TABLE datatype_examples (
    example_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age SMALLINT,
    tuition NUMERIC(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    joined_on DATE DEFAULT CURRENT_DATE,
    last_login_at TIMESTAMPTZ,
    profile JSONB DEFAULT '{}'::jsonb,
    memo TEXT
);

COMMENT ON TABLE datatype_examples IS 'PostgreSQL 데이터 타입 실습 예제 테이블';
COMMENT ON COLUMN datatype_examples.example_id IS '예제 데이터를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN datatype_examples.student_name IS '수강생 이름';
COMMENT ON COLUMN datatype_examples.age IS '수강생 나이';
COMMENT ON COLUMN datatype_examples.tuition IS '수강료 금액';
COMMENT ON COLUMN datatype_examples.is_active IS '활성 상태 여부';
COMMENT ON COLUMN datatype_examples.joined_on IS '가입일';
COMMENT ON COLUMN datatype_examples.last_login_at IS '마지막 로그인 시각';
COMMENT ON COLUMN datatype_examples.profile IS 'JSONB 형식의 추가 프로필 정보';
COMMENT ON COLUMN datatype_examples.memo IS '메모';

INSERT INTO datatype_examples (
    student_name,
    age,
    tuition,
    last_login_at,
    profile,
    memo
) VALUES (
    '김민준',
    24,
    120000.00,
    now(),
    '{"track": "backend", "level": "beginner"}',
    'PostgreSQL 데이터 타입 실습'
);

SELECT
    example_id,
    student_name,
    age,
    tuition,
    is_active,
    joined_on,
    last_login_at,
    profile,
    memo
FROM datatype_examples;

-- 테이블 구조 확인
-- psql에서는 아래 메타 명령을 직접 실행할 수 있습니다.
-- \d datatype_examples

ALTER TABLE datatype_examples
ADD COLUMN email VARCHAR(120);

COMMENT ON COLUMN datatype_examples.email IS '수강생 이메일';

ALTER TABLE datatype_examples
ALTER COLUMN memo TYPE VARCHAR(500);

ALTER TABLE datatype_examples
DROP COLUMN email;

SELECT *
FROM datatype_examples;
