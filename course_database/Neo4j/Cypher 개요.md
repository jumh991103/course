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
# [Cypher란?](https://neo4j.com/docs/cypher/)
- Cypher는 Neo4j에서 노드, 관계, 속성 등을 생성하고 탐색할 수 있도록 설계된 선언적(declarative) 그래프 쿼리 언어입니다.
- 사람이 읽고 쓰기 쉬운 문법으로 되어 있어서, 복잡한 그래프 쿼리도 직관적으로 표현할 수 있는 것이 큰 장점입니다.

---
## 기본 개념 요약

| 개념                    | 설명            | 예시                        |
| --------------------- | ------------- | ------------------------- |
| **노드 (Node)**         | 개체 (사람, 기술 등) | `(p:Person {name: "경원"})` |
| **관계 (Relationship)** | 노드 간의 연결      | `[:KNOWS]`, `[:WORKS_AT]` |
| **속성 (Property)**     | 노드/관계의 정보     | `{name: "윤서", age: 30}`   |
| **패턴 (Pattern)**      | 노드와 관계의 구조 표현 | `(a)-[:MARRIED_TO]->(b)`  |

---
## 자주 쓰는 Cypher 키워드

| 키워드      | 기능                      |
| -------- | ----------------------- |
| `CREATE` | 노드 또는 관계 생성             |
| `MATCH`  | 특정 패턴과 일치하는 그래프 요소 찾기   |
| `RETURN` | 결과 반환                   |
| `WHERE`  | 조건 필터링                  |
| `MERGE`  | 있으면 유지, 없으면 생성 (UPSERT) |
| `SET`    | 속성 추가/수정                |
| `DELETE` | 노드 또는 관계 삭제             |

---
## Cypher vs SQL 비교
| 기능      | SQL                    | Cypher                      |
| ------- | ---------------------- | --------------------------- |
| 데이터 모델  | 테이블 기반                 | 그래프 기반 (노드, 관계)             |
| JOIN 방식 | 명시적으로 JOIN             | 관계 패턴으로 자연스럽게 표현            |
| 예시      | `SELECT * FROM people` | `MATCH (p:Person) RETURN p` |

---
## 정리
- Cypher는 그래프 탐색을 직관적이고 시각적으로 표현할 수 있는 쿼리 언어
- SQL보다 관계 표현이 훨씬 자연스럽고 간결함
- Neo4j를 활용하는 GraphRAG, 지식그래프, 추천 시스템, 네트워크 분석 등에서 핵심 도구로 사용됨

---
## Neo4j 생성

---
### 1. 단계: Docker desktop 실행 
![alt text](./img/image-4.png)

---
### 2. 단계: Neo4j Docker 생성 및 실행 
```shell
# 윈도우용 
docker run -d `
    --restart always `
    --publish=7474:7474 --publish=7687:7687 `
    --env NEO4J_AUTH=neo4j/test1234 `
    neo4j:2025.06.0
```
![alt text](./img/image-5.png)

---
### 3. 단계: Neo4j 접속 
![alt text](./img/image-6.png)

---
- 접속 url: http://localhost:7474
- database user: neo4j
- password: test1234
![bg right w:600](./img/image-7.png)

---
![alt text](./img/image-8.png)

---
## Cypher 쿼리 예제
### 노드 생성
```cypher
// Person 레이블을 가진 노드를 생성하고, name과 job 속성을 설정
CREATE (:Person {name: '홍길동', job: 'AI강사'})
```
![alt text](./img/image-9.png)

---
![alt text](./img/image-10.png)

---
### 관계 생성
```cypher
// 신사임당 노드 생성
CREATE (:Person {name: '신사임당', job: '웹개발강사'})
```
```cypher
// 홍길동과 신사임당 노드를 각각 찾아서 변수 a, b에 할당
MATCH (a:Person {name: '홍길동'}), (b:Person {name: '신사임당'})
// 홍길동에서 신사임당으로 향하는 MARRIED_TO 관계 생성
CREATE (a)-[:MARRIED_TO]->(b)
```
![alt text](./img/image-11.png)

---
![alt text](./img/image-12.png)

---
### 관계 기반 조회
```cypher
// MARRIED_TO 관계로 연결된 Person 노드들을 찾아서
MATCH (a:Person)-[:MARRIED_TO]->(b:Person)
// 각 노드의 name 속성을 반환
RETURN a.name, b.name
```
![alt text](./img/image-13.png)

---
### 조건 검색
```cypher
// 모든 Person 노드를 찾아서
MATCH (p:Person)
// name 속성이 '신사임당'인 노드만 필터링
WHERE p.name = '신사임당'
// 해당 노드 전체 반환
RETURN p
```
![alt text](./img/image-14.png)

---
### 연결된 경로 검색
```cypher
// 1단계부터 3단계까지 연결된 Person 노드들의 경로를 찾아서
MATCH path = (p1:Person)-[*1..3]-(p2:Person)
// 시작점이 '홍길동'인 경로만 필터링
WHERE p1.name = '홍길동'
// 전체 경로 반환
RETURN path
```
![alt text](./img/image-15.png)

---
### 데이터 삭제
```cypher
// name이 '홍길동'인 Person 노드를 찾아서
MATCH (p:Person {name: '홍길동'})
// 관계까지 포함하여 완전히 삭제 (DETACH DELETE)
DETACH DELETE p
```
![alt text](./img/image-16.png)
