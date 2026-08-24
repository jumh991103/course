-- ###############################################
-- 사용자 계정
-- DCL은 데이터베이스 사용자와 권한을 관리하는 명령입니다.
-- 운영 DB에서는 계정 생성/삭제, 권한 부여를 반드시 관리자 승인 후 실행해야 합니다.
-- ###############################################

-- 사용자 확인: MySQL 계정 정보는 mysql 데이터베이스의 user 테이블에서 확인합니다.
use mysql;
select * from user;

-- 로컬에서만 접속 가능한 localid 생성
-- '사용자'@'호스트' 형식이며, localhost는 DB 서버 내부 접속만 허용합니다.
create user 'localid'@localhost identified by '111111111';
-- 결과 확인
select * from user;

-- 모든 호스트에서 접속 가능한 allid 생성
-- '%'는 어디서든 접속 가능하다는 뜻이라 실무에서는 신중하게 사용합니다.
create user 'allid'@'%' identified by '222222222';
-- 결과 확인
select * from user;

-- 사용자 비밀번호 변경
set password for 'allid'@'%' = '333333333';
-- 결과 확인
select * from user;

-- 사용자 삭제
drop user 'localid'@localhost;
-- 결과 확인
select * from user;


-- ###############################################
-- 사용자 권한
-- GRANT는 사용자에게 할 수 있는 작업을 허용하는 명령입니다.
-- ###############################################

use mysql;

-- classicmodels 데이터베이스의 모든 테이블에 모든 권한 부여
grant all privileges on classicmodels.* to 'allid'@'%';
-- 권한 테이블을 다시 읽어 변경 사항을 반영합니다.
FLUSH PRIVILEGES;
-- 결과 확인
select * from user;

-- SELECT만 권한 부여: 데이터를 조회할 수 있지만 INSERT/UPDATE/DELETE는 할 수 없습니다.
grant select on classicmodels.* to 'allid'@'%';
-- 권한 테이블 다시 읽기
FLUSH PRIVILEGES;
-- 결과 확인
select * from user;

-- SELECT와 INSERT 권한 부여: 조회와 데이터 추가를 허용합니다.
grant select,insert on classicmodels.* to 'allid'@'%';
-- 권한 테이블 다시 읽기
FLUSH PRIVILEGES;
-- 결과 확인
select * from user;








