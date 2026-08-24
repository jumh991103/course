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
# DML(Data Manipulation Language)
> DML은 데이터를 삽입(`INSERT`), 수정(`UPDATE`), 삭제(`DELETE`), 조회(`SELECT`)하는 구문입니다.

하지만 실무 및 교육 관점에서는 보통 아래와 같이 구분합니다.

- DML(데이터를 변경): `INSERT`, `UPDATE`, `DELETE`
- DQL(데이터를 조회): `SELECT`

---
## INSERT 기본 구조
> `INSERT`는 테이블에 새로운 행(row)을 추가하는 구문입니다.

```sql
INSERT INTO 테이블명 (컬럼1, 컬럼2, 컬럼3)
VALUES (값1, 값2, 값3);
```

- 컬럼 목록과 값 목록은 순서와 개수가 같아야 합니다.
- `GENERATED AS IDENTITY`, `DEFAULT` 값이 있는 컬럼은 보통 생략할 수 있습니다.

> 예시코드
```sql
INSERT INTO students (name, email, birth_date, phone)
VALUES ('오하늘', 'haneul@example.com', '2002-04-03', '010-7777-7777')
RETURNING student_id, name, email;
```

---
### INSERT 여러 행 추가
> 같은 테이블에 여러 행을 한 번에 추가할 수도 있습니다.

```sql
INSERT INTO students (name, email, birth_date, phone)
VALUES
    ('강지민', 'jimin.kang@example.com', '2001-06-10', '010-8888-8888'),
    ('윤서준', 'seojun.yoon@example.com', '2000-12-21', '010-9999-9999')
RETURNING student_id, name, email;
```

---
## PostgreSQL의 RETURNING
> PostgreSQL은 `INSERT`, `UPDATE`, `DELETE` 뒤에 `RETURNING`을 붙여 변경된 행을 바로 확인할 수 있습니다.

```sql
INSERT INTO students (name, email)
VALUES ('반환확인', 'returning@example.com')
RETURNING student_id, name, email;
```

MySQL에서는 보통 데이터를 변경한 뒤 별도의 `SELECT`로 결과를 확인하지만,
PostgreSQL에서는 `RETURNING`으로 변경 결과를 바로 받을 수 있습니다.

---
## UPDATE 기본 구조
> `UPDATE`는 이미 저장된 행의 값을 수정하는 구문입니다.

```sql
UPDATE 테이블명
SET 컬럼1 = 새값1,
    컬럼2 = 새값2
WHERE 조건;
```

- `WHERE`가 없으면 테이블의 모든 행이 수정될 수 있습니다.

> 예시코드
```sql
UPDATE students
SET phone = '010-7777-0000'
WHERE 1=1
  AND email = 'haneul@example.com'
RETURNING student_id, name, phone;
```

---
### UPDATE 전 확인
> 수정하기 전에 같은 `WHERE` 조건으로 대상 행을 먼저 조회합니다.

```sql
SELECT
    student_id,
    name,
    phone
FROM students
WHERE 1=1
  AND email = 'haneul@example.com';
```

---
## DELETE 기본 구조
> `DELETE`는 테이블에서 조건에 맞는 행을 삭제하는 구문입니다.

```sql
DELETE FROM 테이블명
WHERE 조건;
```

- `WHERE`가 없으면 테이블의 모든 행이 삭제될 수 있습니다.

> 예시코드
```sql
DELETE FROM students
WHERE 1=1
  AND email = 'haneul@example.com'
RETURNING student_id, name, email;
```

---
### DELETE 전 확인
> 삭제하기 전에 같은 `WHERE` 조건으로 대상 행을 먼저 조회합니다.

```sql
SELECT
    student_id,
    name,
    email
FROM students
WHERE 1=1
  AND email = 'haneul@example.com';
```

---
## SELECT 기본 구조
> `SELECT *`는 학습 단계에서는 편리하지만, 실무에서는 필요한 컬럼을 명시하는 습관이 좋습니다.

```sql
SELECT 컬럼명
FROM 테이블명
WHERE 조건
ORDER BY 정렬기준
LIMIT 개수;
```

---
> 예시코드
```sql
SELECT
    title,
    rental_rate,
    rating
FROM film
WHERE 1=1
  AND rental_rate >= 4.99
ORDER BY rental_rate DESC, title
LIMIT 20;
```

---
## PostgreSQL 조건 조회 팁
> PostgreSQL에서는 대소문자를 구분하지 않는 문자열 검색에 `ILIKE`를 사용할 수 있습니다.

```sql
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE first_name ILIKE 'ann%'
ORDER BY first_name, last_name;
```

