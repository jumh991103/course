import os
from pathlib import Path

import enum 

class FileSize(enum.Enum):
  MAX_FS_READ_BYTES = 256 * 1024
  MAX_FS_WRITE_BYTES = 64 * 1024

def _fs_root() -> Path:
    raw = os.environ.get("MCP_FS_ROOT", "").strip()
    if not raw:
        raise RuntimeError(
            "MCP_FS_ROOT가 비어 있습니다. .env.example을 참고해 허용할 디렉터리 절대 경로를 설정하세요."
        )
    return Path(raw).resolve()


def resolve_safe_path(relative_path: str) -> Path:
    rel = relative_path.strip().replace("\\", "/").lstrip("/")
    if not rel or ".." in Path(rel).parts:
        raise RuntimeError("상대 경로만 허용되며 '..'를 포함할 수 없습니다.")
    root = _fs_root()
    candidate = (root / rel).resolve()
    try:
        candidate.relative_to(root)
    except ValueError as e:
        raise RuntimeError("허용된 디렉터리 밖의 경로입니다.") from e
    return candidate

