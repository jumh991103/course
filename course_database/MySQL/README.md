---
style: |
  img {
    display: block;
    float: none;
    margin-left: auto;
    margin-right: auto;
  }
marp: true
paginate: true
---
# [MySQL](https://www.mysql.com/)
- MySQL은 전 세계에서 가장 많이 사용되는 오픈소스 관계형 데이터베이스(RDBMS) 입니다.

```
[사용자] → SQL 명령어 → [MySQL 서버] → [데이터 저장/조회]
```

---
## SQL이란?
 
> **SQL(Structured Query Language)** 은 데이터베이스에 명령을 내리는 **언어**입니다.
 
쉽게 말해, MySQL에게 "이 데이터 찾아줘", "이 데이터 저장해줘" 같이 말을 거는 방법입니다.
 
```sql
-- 회원 테이블에서 모든 데이터 조회
SELECT * FROM 회원;
 
-- 이름이 '홍길동'인 회원만 조회
SELECT * FROM 회원 WHERE 이름 = '홍길동';
```

---
SQL 명령어는 크게 4가지로 나뉩니다:
 
| 종류 | 명령어 | 하는 일 |
|------|--------|--------|
| 조회 | `SELECT` | 데이터 읽기 |
| 삽입 | `INSERT` | 데이터 추가 |
| 수정 | `UPDATE` | 데이터 변경 |
| 삭제 | `DELETE` | 데이터 제거 |

---
## MySQL은 어디서 쓰이나요?
 > MySQL은 우리가 매일 사용하는 서비스 뒤에 숨어 있습니다.
 
| 서비스 | 활용 예시 |
|--------|---------|
| 쇼핑몰 | 상품 정보, 주문 내역 저장 |
| SNS | 게시글, 댓글, 친구 목록 저장 |
| 은행 앱 | 계좌 정보, 거래 내역 저장 |
| 게임 | 캐릭터 정보, 아이템 목록 저장 |
| 병원 | 환자 정보, 진료 기록 저장 |

---
## 왜 MySQL을 배워야 하나요?

### 이유 1: 가장 많이 쓰이는 DB
 
- 전 세계 웹 개발자의 절반 이상이 MySQL 사용
- 스타트업부터 대기업까지 폭넓게 채택
- 채용 공고에서 MySQL 경험을 가장 많이 요구

### 이유 2: 무료이고 배우기 쉬움
 
- **오픈소스** → 무료로 설치하고 사용 가능
- SQL 문법이 **영어 문장과 비슷**해서 직관적
- 방대한 한국어 자료와 커뮤니티

---
### 이유 3: 백엔드 개발의 필수 기술
 
- Python, Java, Node.js 등 어떤 언어로 개발해도 **MySQL 연동은 필수**
- FastAPI, Django, Spring 등 대부분의 프레임워크가 MySQL을 기본 지원

### 이유 4: SQL은 한 번 배우면 다 쓸 수 있다
 
- MySQL, PostgreSQL, Oracle, SQLite → **SQL 문법이 거의 동일**
- MySQL 익히면 다른 DB도 쉽게 전환 가능

---
## MySQL vs 다른 데이터베이스
 
| 비교 | MySQL | PostgreSQL | MongoDB | SQLite |
|------|-------|------------|---------|--------|
| 종류 | 관계형(RDB) | 관계형(RDB) | 비관계형(NoSQL) | 관계형(RDB) |
| 비용 | 무료 | 무료 | 무료 | 무료 |
| 난이도 | 쉬움 | 보통 | 보통 | 쉬움 |
| 사용처 | 웹 서비스 전반 | 복잡한 쿼리, 분석 | 빠른 개발, 유연한 구조 | 앱 내부, 소규모 |
| 특징 | 빠르고 안정적 | 기능 풍부 | 문서 기반 | 파일 1개로 동작 |

---
## 실습 환경 준비
> `MySQL` 폴더에서 MySQL 컨테이너를 실행합니다.

```shell
docker-compose up -d
```

---
> MySQL 접속 정보는 `docker-compose.yml`에 맞춰 아래 값을 사용합니다.

| 항목 | 값 |
|---|---|
| Host | `localhost` |
| Port | `3306` |
| Database | `examplesdb` |
| User | `urstory` |
| Password | `u1234` |
| Root Password | `root1234` |

