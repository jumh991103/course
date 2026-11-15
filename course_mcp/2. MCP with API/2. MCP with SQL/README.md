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
# MCP with SQL

---
## PostgreSQL
`postgresql` 디렉터리에서 컨테이너를 띄웁니다.

```bash
cd postgresql
docker compose up -d
```

- **최초 한 번만** `init/` 아래 SQL이 실행됩니다. 이미 `database/` 볼륨이 있으면 초기화는 건너뜁니다. 스키마를 다시 넣고 싶다면 컨테이너와 `database/` 폴더를 삭제한 뒤 다시 올리세요.
- 기본 연결 정보: 사용자 `admin`, 비밀번호 `admin123`, DB `mcp_db`, 포트 `5432` (`docker-compose.yml`과 동일).

---
### Docker Container 확인

![alt text](./img/image.png)

---
### Database 및 Tables 확인

![alt text](./img/image-1.png)

---
## MCP Server

---
### 가상환경 구축 
프로젝트 루트(`2. MCP with SQL`)에서 가상환경과 의존성을 설치합니다.

```bash
uv venv .venv --python 3.13
```

- **Windows** PowerShell에서는 `.\.venv\Scripts\Activate.ps1` 로 활성화할 수 있습니다.

---
### `.env` 설정
`.env.example`을 복사해 `.env`를 만들고 값을 채웁니다.

- `DATABASE_URL`: 예) `postgresql://admin:admin123@localhost:5432/mcp_db`
- `MCP_FS_ROOT`: 파일 도구가 접근할 **절대 경로**. 예제는 저장소 안의 `mcp_workspace`를 가리키면 됩니다.

`.env`는 **커밋하지 않습니다** (`.gitignore`에 포함).

---
### stdio로 Cursor에 연결 (권장)

```json
"course-sql-mcp": {
  "command": "C:/develop/github/course_LLM/6. MCP/3. MCP with API/2. MCP with SQL/.venv/Scripts/python.exe",
  "args": ["C:/develop/github/course_LLM/6. MCP/3. MCP with API/2. MCP with SQL/example_sql_mcp.py"],
  "cwd": "C:/develop/github/course_LLM/6. MCP/3. MCP with API/2. MCP with SQL"
}
```
![alt text](./img/image-3.png)

---
## 테스트 

| 도구 | 목적 |
|------|------|
| `db_list_low_stock_products` | 재고 부족 SKU 조회 (`Literal`로 상한·개수 제한) |
| `db_search_products_by_name` | 이름 검색(부분/접두) |
| `db_customer_order_summary` | 최근 주문 또는 이메일별 주문 |
| `fs_read_text_file` | 허용 루트 내 읽기(크기 상한) |
| `fs_write_text_file` | 허용 루트 내 쓰기(create/overwrite) |

---
### 테스트 > 재고 5개 이하인 상품만 알려줘 
>  `db_list_low_stock_products`

![alt text](./img/image-4.png)

---
### 테스트 > 이메일이 minsu@example.com 인 고객 주문 보여줘.
> `db_customer_order_summary`

![bg right w:650](./img/image-5.png)

---
### 테스트 > mcp_workspace에 notes.txt로 Hello World 저장해.
> `fs_write_text_file` (허용 경로 내)

![alt text](./img/image-6.png)
