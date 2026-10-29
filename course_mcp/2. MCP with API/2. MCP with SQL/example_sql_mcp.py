import asyncio
import os
import sys
from typing import Literal

from dotenv import load_dotenv
from fastmcp import FastMCP

from common.fs import resolve_safe_path, FileSize
from common.sql import get_pool, DBSize

load_dotenv()

mcp = FastMCP(
    "Course — SQL & API",
    instructions=(
        "PostgreSQL 샘플 DB(mcp_db)의 고객·상품·주문을 조회하고, "
        "JSONPlaceholder GET 요청과 허용 디렉터리 내 파일 읽기/쓰기를 제공한다. "
        "재고·가격·주문 내역은 DB 도구, 외부 사용자·게시글 예시는 http_fetch_json_placeholder 도구를 사용한다."
    ),
)


@mcp.tool()
async def db_list_low_stock_products(
    max_stock: Literal[3, 5, 10, 20] = 10,
    limit: Literal[5, 10, 20, 50] = 20,
) -> str:
    """재고가 적은 상품을 찾는다. '품절 임박', '재고 부족', '남은 수량 적은 SKU' 질문에 사용한다. max_stock 이하만 반환."""
    pool = await get_pool()
    lim = min(int(limit), DBSize.MAX_DB_ROWS.value)
    async with pool.acquire() as conn:
        rows = await conn.fetch(
            """
            SELECT sku, name, stock, price_cents
            FROM products
            WHERE stock <= $1
            ORDER BY stock ASC, id
            LIMIT $2
            """,
            int(max_stock),
            lim,
        )
    if not rows:
        return f"(조건: stock <= {max_stock}) 해당 상품 없음"
    lines = [
        f"{r['sku']}: {r['name']} | stock={r['stock']} | price_cents={r['price_cents']}"
        for r in rows
    ]
    return "\n".join(lines)


@mcp.tool()
async def db_search_products_by_name(
    keyword: str,
    match: Literal["contains", "prefix"] = "contains",
    limit: Literal[5, 10, 20] = 10,
) -> str:
    """상품명으로 상품을 검색한다. '키보드', '케이블' 등 이름 키워드로 찾을 때 사용한다."""
    pool = await get_pool()
    kw = keyword.strip()
    if not kw:
        raise RuntimeError("keyword가 비어 있습니다.")
    lim = min(int(limit), DBSize.MAX_DB_ROWS.value)
    pattern = f"{kw}%" if match == "prefix" else f"%{kw}%"
    async with pool.acquire() as conn:
        rows = await conn.fetch(
            """
            SELECT sku, name, price_cents, stock
            FROM products
            WHERE name ILIKE $1
            ORDER BY name
            LIMIT $2
            """,
            pattern,
            lim,
        )
    if not rows:
        return "(검색 결과 없음)"
    return "\n".join(
        f"{r['sku']}: {r['name']} | 가격(원)={r['price_cents']} | stock={r['stock']}" for r in rows
    )


@mcp.tool()
async def db_customer_order_summary(
    scope: Literal["recent", "by_email"],
    email: str | None = None,
    limit: Literal[5, 10, 20] = 10,
) -> str:
    """주문 요약을 조회한다. scope=recent는 최근 주문 전체, scope=by_email은 특정 고객 이메일 기준."""
    pool = await get_pool()
    lim = min(int(limit), DBSize.MAX_DB_ROWS.value)
    async with pool.acquire() as conn:
        if scope == "recent":
            rows = await conn.fetch(
                """
                SELECT o.id, c.email, p.sku, o.qty, o.ordered_at
                FROM orders o
                JOIN customers c ON c.id = o.customer_id
                JOIN products p ON p.id = o.product_id
                ORDER BY o.ordered_at DESC
                LIMIT $1
                """,
                lim,
            )
        else:
            if not email or not email.strip():
                raise RuntimeError("scope=by_email 일 때 email이 필요합니다.")
            rows = await conn.fetch(
                """
                SELECT o.id, c.email, p.sku, o.qty, o.ordered_at
                FROM orders o
                JOIN customers c ON c.id = o.customer_id
                JOIN products p ON p.id = o.product_id
                WHERE c.email = $1
                ORDER BY o.ordered_at DESC
                LIMIT $2
                """,
                email.strip(),
                lim,
            )
    if not rows:
        return "(주문 없음)"
    lines = [
        f"order#{r['id']} {r['email']} {r['sku']} x{r['qty']} @ {r['ordered_at']}" for r in rows
    ]
    return "\n".join(lines)


@mcp.tool()
async def fs_read_text_file(relative_path: str) -> str:
    """허용 루트(MCP_FS_ROOT) 아래 텍스트 파일을 읽는다. 노트·로그·설정 확인에 사용한다."""
    path = resolve_safe_path(relative_path)
    if not path.is_file():
        raise RuntimeError("파일이 없거나 파일이 아닙니다.")
    data = path.read_bytes()
    if len(data) > FileSize.MAX_FS_READ_BYTES.value:
        raise RuntimeError(f"파일이 너무 큽니다(최대 {FileSize.MAX_FS_READ_BYTES.value}바이트).")
    return data.decode("utf-8", errors="replace")


@mcp.tool()
async def fs_write_text_file(
    relative_path: str,
    content: str,
    mode: Literal["create", "overwrite"] = "create",
) -> str:
    """허용 루트 아래에 텍스트를 쓴다. mode=create는 기존 파일이 있으면 실패, overwrite는 덮어쓴다."""
    path = resolve_safe_path(relative_path)
    raw = content.encode("utf-8")
    if len(raw) > FileSize.MAX_FS_WRITE_BYTES.value:
        raise RuntimeError(f"내용이 너무 큽니다(최대 {FileSize.MAX_FS_WRITE_BYTES.value}바이트).")
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and mode == "create":
        raise RuntimeError("파일이 이미 있어 create 모드로 쓸 수 없습니다.")
    path.write_bytes(raw)
    return f"저장 완료: {path} ({len(raw)} bytes)"


def main() -> None:
    if "--sse" in sys.argv:
        asyncio.run(
            mcp.run_http_async(
                transport="sse",
                host=os.environ.get("MCP_HTTP_HOST", "127.0.0.1"),
                port=int(os.environ.get("MCP_HTTP_PORT", "8765")),
            )
        )
    else:
        mcp.run()


if __name__ == "__main__":
    main()
