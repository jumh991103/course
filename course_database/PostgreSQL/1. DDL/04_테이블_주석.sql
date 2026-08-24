-- PostgreSQL DDL 기초 04
-- 테이블과 컬럼 주석: COMMENT ON TABLE, COMMENT ON COLUMN

DROP TABLE IF EXISTS comment_examples;

CREATE TABLE comment_examples (
    comment_example_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE comment_examples IS '테이블과 컬럼 주석 작성법을 실습하는 예제 테이블';
COMMENT ON COLUMN comment_examples.comment_example_id IS '주석 예제 데이터를 식별하는 자동 증가 기본키';
COMMENT ON COLUMN comment_examples.title IS '예제 제목';
COMMENT ON COLUMN comment_examples.description IS '예제 설명';
COMMENT ON COLUMN comment_examples.created_at IS '예제 생성 시각';

-- 테이블 주석 확인
SELECT obj_description('comment_examples'::regclass, 'pg_class') AS table_comment;

-- 컬럼 주석 확인
SELECT
    column_name,
    col_description('comment_examples'::regclass, ordinal_position::int) AS column_comment
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'comment_examples'
ORDER BY ordinal_position;
