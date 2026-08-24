-- MySQL DML 기초
-- CRUD: INSERT, SELECT, UPDATE, DELETE
-- CRUD는 대부분의 애플리케이션에서 데이터를 다루는 기본 흐름입니다.

USE examplesdb;

-- ###############################################
-- INSERT는 테이블에 새로운 행(row)을 추가합니다.
-- ###############################################
INSERT INTO students (name, email, birth_date, phone)
VALUES ('오하늘', 'haneul@example.com', '2002-04-03', '010-7777-7777');

-- ###############################################
-- READ: 데이터 조회
-- ###############################################
-- 방금 입력한 데이터만 확인하기 위해 email로 조건을 좁힙니다.
SELECT
    student_id,
    name,
    email
FROM students
WHERE email = 'haneul@example.com';

-- READ: 데이터 조회
-- SELECT는 저장된 데이터를 읽습니다. ORDER BY로 출력 순서를 고정하면 결과 비교가 쉽습니다.
SELECT
    student_id,
    name,
    email,
    phone,
    created_at
FROM students
ORDER BY student_id;

-- ###############################################
-- UPDATE: 데이터 수정
-- ###############################################
-- WHERE 없이 UPDATE를 실행하면 모든 행이 바뀔 수 있으므로 항상 조건을 확인합니다.
UPDATE students
SET phone = '010-7777-0000'
WHERE email = 'haneul@example.com';

-- 수정된 값이 의도대로 반영되었는지 확인합니다.
SELECT
    student_id,
    name,
    phone
FROM students
WHERE email = 'haneul@example.com';

-- ###############################################
-- DELETE: 데이터 삭제
-- ###############################################
-- DELETE도 WHERE 조건이 없으면 모든 행을 삭제할 수 있으므로 주의합니다.
DELETE FROM students
WHERE email = 'haneul@example.com';

-- 삭제 결과 확인
SELECT
    student_id,
    name,
    email
FROM students
ORDER BY student_id;
