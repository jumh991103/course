-- PostgreSQL DML 기초
-- CRUD: INSERT, SELECT, UPDATE, DELETE

-- CREATE: 데이터 추가
INSERT INTO students (name, email, birth_date, phone)
VALUES ('오하늘', 'haneul@example.com', '2002-04-03', '010-7777-7777')
RETURNING student_id, name, email;

-- READ: 데이터 조회
SELECT
    student_id,
    name,
    email,
    phone,
    created_at
FROM students
ORDER BY student_id;

-- UPDATE: 데이터 수정
UPDATE students
SET phone = '010-7777-0000'
WHERE email = 'haneul@example.com'
RETURNING student_id, name, phone;

-- DELETE: 데이터 삭제
DELETE FROM students
WHERE email = 'haneul@example.com'
RETURNING student_id, name, email;

-- 삭제 결과 확인
SELECT
    student_id,
    name,
    email
FROM students
ORDER BY student_id;
