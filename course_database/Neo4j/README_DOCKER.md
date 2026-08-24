# Neo4j Docker Compose 사용 가이드

## 사전 요구사항
- Docker 설치
- Docker Compose 설치

## 빠른 시작

### 1. Neo4j 실행
```bash
docker-compose up -d
```

### 2. Neo4j 접속
- **Neo4j Browser**: http://localhost:7474
- **기본 사용자명**: `neo4j`
- **기본 비밀번호**: `test1234`

### 3. Neo4j 중지
```bash
docker-compose down
```

### 4. 데이터 유지하면서 중지
```bash
docker-compose stop
```

## 주요 명령어

### 로그 확인
```bash
docker-compose logs -f neo4j
```

### 컨테이너 상태 확인
```bash
docker-compose ps
```

### 데이터 초기화 (주의: 모든 데이터 삭제)
```bash
docker-compose down -v
```

### Neo4j 재시작
```bash
docker-compose restart neo4j
```

## 포트 정보
- **7474**: Neo4j Browser (HTTP)
- **7687**: Bolt 프로토콜 (애플리케이션 연결)

## 볼륨 정보
- `neo4j_data`: 데이터베이스 데이터
- `neo4j_logs`: 로그 파일
- `neo4j_import`: CSV 등 임포트 파일 위치
- `neo4j_plugins`: 플러그인 파일

## 환경 변수 변경
1. `.env.example` 파일을 `.env`로 복사
2. `.env` 파일에서 원하는 값 수정
3. `docker-compose.yml`에서 환경 변수 참조 방식으로 변경 (선택사항)

## 문제 해결

### 포트 충돌
다른 포트를 사용하려면 `docker-compose.yml`의 `ports` 섹션을 수정하세요:
```yaml
ports:
  - "7475:7474"  # 외부 포트 변경
  - "7688:7687"
```

### 메모리 부족
`docker-compose.yml`의 메모리 설정을 조정하세요:
```yaml
environment:
  - NEO4J_dbms_memory_heap_max__size=1G
  - NEO4J_dbms_memory_pagecache_size=512m
```

