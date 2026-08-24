-- ###############################################
-- 데이터베이스 생성
-- IF NOT EXISTS: 같은 이름의 데이터베이스가 이미 있으면 오류 없이 넘어갑니다.
-- utf8mb4: 한글, 특수문자, 이모지까지 안전하게 저장하기 위한 문자셋입니다.
-- ###############################################
CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 이 아래 SQL은 mysql_ddl_practice 데이터베이스 안에서 실행됩니다.
USE mysql_ddl_practice;

-- ###############################################
-- 테이블 생성
-- 테이블은 행(row)과 열(column)로 데이터를 저장하는 기본 단위입니다.
-- 각 컬럼은 저장할 값의 종류에 맞는 데이터 타입을 가집니다.
-- ###############################################
-- 같은 이름의 테이블이 남아 있으면 새로 만들 수 없으므로 먼저 삭제합니다.
DROP TABLE IF EXISTS datatype_examples;

-- 여러 데이터 타입을 한 테이블에서 비교해 보기 위한 예제입니다.
CREATE TABLE datatype_examples (
    example_id INT AUTO_INCREMENT COMMENT '예제 데이터를 식별하는 자동 증가 기본키',
    student_name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    age SMALLINT COMMENT '수강생 나이',
    tuition DECIMAL(10, 2) COMMENT '수강료 금액',
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성 상태 여부',
    joined_on DATE DEFAULT (CURRENT_DATE) COMMENT '가입일',
    last_login_at DATETIME COMMENT '마지막 로그인 시각',
    profile JSON COMMENT 'JSON 형식의 추가 프로필 정보',
    memo TEXT COMMENT '메모',
    PRIMARY KEY (example_id)
) COMMENT = 'MySQL 데이터 타입 실습 예제 테이블';

-- 테이블 구조와 주석 확인
DESCRIBE datatype_examples;
SHOW FULL COLUMNS FROM datatype_examples;

-- ALTER TABLE은 이미 만들어진 테이블의 구조를 바꿀 때 사용합니다.
-- ADD COLUMN: 새 컬럼 추가
ALTER TABLE datatype_examples
ADD COLUMN email VARCHAR(120) COMMENT '수강생 이메일';

-- MODIFY COLUMN: 기존 컬럼의 타입, 길이, 주석 등을 변경
ALTER TABLE datatype_examples
MODIFY COLUMN memo VARCHAR(500) COMMENT '메모';

-- DROP COLUMN: 더 이상 필요 없는 컬럼 삭제
ALTER TABLE datatype_examples
DROP COLUMN email;
