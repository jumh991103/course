-- MySQL DDL 기초 실습문제 정답
-- 실행 순서: 데이터베이스 준비 -> 기존 테이블 삭제 -> 새 테이블 생성 -> 샘플 데이터 입력 -> 결과 확인

CREATE DATABASE IF NOT EXISTS mysql_ddl_practice
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE mysql_ddl_practice;

-- 공통 준비: 정답을 여러 번 실행해도 같은 상태에서 시작하도록 기존 테이블을 정리합니다.
-- 외래키 관계가 있으므로 자식 테이블(practice_enrollments)을 먼저 삭제합니다.
DROP TABLE IF EXISTS practice_enrollments;
DROP TABLE IF EXISTS practice_courses;
DROP TABLE IF EXISTS practice_students;

-- ###############################################
-- 문제 1 정답: 수강생 테이블 만들기
-- ###############################################
-- 수강생 테이블: NOT NULL, UNIQUE, DEFAULT, PRIMARY KEY를 확인하는 예제입니다.
CREATE TABLE practice_students (
    student_id INT AUTO_INCREMENT COMMENT '수강생을 식별하는 자동 증가 기본키',
    name VARCHAR(50) NOT NULL COMMENT '수강생 이름',
    email VARCHAR(120) NOT NULL UNIQUE COMMENT '수강생 이메일, 중복 불가',
    birth_date DATE COMMENT '수강생 생년월일',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수강생 등록 시각',
    PRIMARY KEY (student_id)
) COMMENT = 'DDL 실습용 수강생 정보';

-- ###############################################
-- 문제 2 정답: 강의 테이블 만들기
-- ###############################################
-- 강의 테이블: CHECK와 ENUM으로 입력 가능한 값을 제한합니다.
CREATE TABLE practice_courses (
    course_id INT AUTO_INCREMENT COMMENT '강의를 식별하는 자동 증가 기본키',
    title VARCHAR(100) NOT NULL COMMENT '강의명',
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0) COMMENT '강의 가격, 0 이상만 허용',
    level ENUM('beginner', 'intermediate', 'advanced') NOT NULL COMMENT '강의 난이도',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '강의 활성 상태',
    PRIMARY KEY (course_id)
) COMMENT = 'DDL 실습용 강의 정보';

-- ###############################################
-- 문제 3 정답: 수강 신청 테이블 만들기
-- ###############################################
-- 수강 신청 테이블: 수강생과 강의를 연결하는 관계 테이블입니다.
CREATE TABLE practice_enrollments (
    enrollment_id INT AUTO_INCREMENT COMMENT '수강 신청을 식별하는 자동 증가 기본키',
    student_id INT NOT NULL COMMENT '수강 신청한 수강생 ID',
    course_id INT NOT NULL COMMENT '신청한 강의 ID',
    enrolled_at DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '수강 신청일',
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_practice_enrollments_student_course (student_id, course_id),
    CONSTRAINT fk_practice_enrollments_student
        FOREIGN KEY (student_id) REFERENCES practice_students(student_id),
    CONSTRAINT fk_practice_enrollments_course
        FOREIGN KEY (course_id) REFERENCES practice_courses(course_id)
) COMMENT = 'DDL 실습용 수강 신청 정보';
