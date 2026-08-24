
-- 문제 1 정답: 데이터 삽입
-- INSERT INTO 뒤에는 값을 넣을 컬럼 목록을 명시합니다.
INSERT INTO users (username, email, password) VALUES
('kim_coding', 'kim@example.com', 'password123'),
('lee_dev', 'lee@example.com', 'securepass');

-- 문제 2 정답: 데이터 수정
-- UPDATE는 WHERE 조건을 만족하는 행만 수정합니다.
UPDATE users 
SET email = 'kim_new@example.com' 
WHERE username = 'kim_coding';

-- 문제 3 정답: 데이터 삭제
-- WHERE 1=1은 뒤에 AND 조건을 이어 붙이기 쉽게 만드는 관용적인 작성 방식입니다.
-- 실제 삭제 전에는 같은 WHERE 조건으로 SELECT를 먼저 실행해 대상 행을 확인하는 습관이 좋습니다.
DELETE FROM users 
WHERE 1=1
  and username = 'lee_dev';
