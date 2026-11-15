import os
from typing import Any, Literal
from urllib.parse import quote

import httpx
from dotenv import load_dotenv
from fastmcp import FastMCP

load_dotenv()

GITHUB_API = "https://api.github.com"
API_VERSION = "2022-11-28"

mcp = FastMCP("Course — GitHub API")


def _github_headers() -> dict[str, str]:
    token = os.environ.get("GITHUB_TOKEN", "").strip()
    if not token:
        raise RuntimeError(
            "GITHUB_TOKEN 환경 변수가 없습니다. .env.example을 참고해 .env를 설정하세요."
        )
    return {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": API_VERSION,
        "Authorization": f"Bearer {token}",
        "User-Agent": "course-llm-github-mcp",
    }


async def _get_json(client: httpx.AsyncClient, url: str) -> Any:
    r = await client.get(url, headers=_github_headers())
    try:
        r.raise_for_status()
    except httpx.HTTPStatusError as e:
        detail: str
        try:
            body = e.response.json()
            detail = str(body.get("message", body))
        except Exception:
            detail = e.response.text or str(e)
        raise RuntimeError(f"GitHub API 오류 {e.response.status_code}: {detail}") from e
    return r.json()


@mcp.tool()
async def get_repository(
    owner: str,
    repo: str,
) -> str:
    """공개 또는 토큰 권한이 닿는 저장소의 메타데이터를 요약 문자열로 반환한다. 설명·스타·포크·언어·홈페이지 조회에 쓴다."""
    owner, repo = owner.strip(), repo.strip()
    url = f"{GITHUB_API}/repos/{owner}/{repo}"
    async with httpx.AsyncClient(timeout=30.0) as client:
        data = await _get_json(client, url)
    if not isinstance(data, dict):
        return str(data)
    desc = data.get("description") or "(설명 없음)"
    return (
        f"{data.get('full_name')}: {desc}\n"
        f"stars={data.get('stargazers_count')}, forks={data.get('forks_count')}, "
        f"language={data.get('language')}, homepage={data.get('homepage') or '-'}\n"
        f"default_branch={data.get('default_branch')}, open_issues={data.get('open_issues_count')}"
    )


@mcp.tool()
async def list_repository_issues(
    owner: str,
    repo: str,
    state: Literal["open", "closed", "all"] = "open",
    per_page: int = 5,
) -> str:
    """저장소 이슈 목록을 가져온다. PR은 GitHub API상 이슈에 포함될 수 있으므로 필요 시 응답에서 필터링한다."""
    owner, repo = owner.strip(), repo.strip()
    per_page = max(1, min(per_page, 30))
    url = (
        f"{GITHUB_API}/repos/{owner}/{repo}/issues"
        f"?state={state}&per_page={per_page}&sort=updated"
    )
    async with httpx.AsyncClient(timeout=30.0) as client:
        items = await _get_json(client, url)
    if not isinstance(items, list):
        return str(items)
    lines: list[str] = []
    for it in items:
        if not isinstance(it, dict):
            continue
        if "pull_request" in it:
            continue
        num = it.get("number")
        title = it.get("title", "")
        lines.append(f"#{num} {title}")
    if not lines:
        return "(표시할 이슈 없음 — PR만 있거나 목록이 비었습니다.)"
    return "\n".join(lines)


@mcp.tool()
async def search_repositories(
    query: str,
    per_page: int = 5,
) -> str:
    """GitHub 저장소 검색(q 쿼리 문법은 GitHub 검색 문서 참고). 주제·언어·이름 키워드로 후보를 찾을 때 쓴다."""
    q = query.strip()
    per_page = max(1, min(per_page, 10))
    url = f"{GITHUB_API}/search/repositories?q={quote(q)}&per_page={per_page}"
    async with httpx.AsyncClient(timeout=30.0) as client:
        data = await _get_json(client, url)
    items = data.get("items") if isinstance(data, dict) else None
    if not isinstance(items, list):
        return str(data)
    lines: list[str] = []
    for it in items:
        if not isinstance(it, dict):
            continue
        name = it.get("full_name", "")
        desc = (it.get("description") or "")[:120]
        stars = it.get("stargazers_count", "")
        lines.append(f"{name} ★{stars} — {desc}")
    return "\n".join(lines) if lines else "(검색 결과 없음)"


if __name__ == "__main__":
    mcp.run()
