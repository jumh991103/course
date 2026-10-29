import os

import asyncpg
import enum

class DBSize(enum.Enum):
  MAX_DB_ROWS = 1000


_pool: asyncpg.Pool | None = None

async def get_pool() -> asyncpg.Pool:
    global _pool
    if _pool is None:
        dsn = os.environ.get("DATABASE_URL", "").strip()
        if not dsn:
            raise RuntimeError(
                "DATABASE_URL이 없습니다. PostgreSQL 기동 후 .env에 연결 문자열을 설정하세요."
            )
        _pool = await asyncpg.create_pool(dsn, min_size=1, max_size=4, command_timeout=60)
    return _pool

  