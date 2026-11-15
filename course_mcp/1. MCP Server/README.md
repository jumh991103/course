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
# MCP Server 개발

## 사용 라이브러리
- [FastMCP](https://gofastmcp.com/) (Python MCP 서버 SDK)

## 환경 준비
```bash
pip install -r requirements.txt
```

---
## MCP(Model Context Protocol)란?

MCP는 **LLM 애플리케이션이 외부 도구·데이터·프롬프트 템플릿에 접근하는 방식을 표준화**한 프로토콜입니다. “한 클라이언트가 여러 서버에 붙어서, 같은 방식으로 기능을 쓴다”는 그림을 목표로 합니다.

```text
┌───────────────────┐     MCP (JSON-RPC 등)     ┌────────────────────┐
│  MCP 클라이언트   │ ◄───────────────────────► │   MCP 서버         │
│ (IDE, 챗봇 앱 등) │                           │ (이 강의: FastMCP) │
└───────────────────┘                           └────────────────────┘
        │                                                │
        │  tools/call, resources/read,                   │
        │  prompts/get …                                 │
        ▼                                                ▼
   사용자 대화·에이전트 로직                    파일, DB, API, 로컬 함수
```

---
## 서버 쪽에서 기억할 세 가지 + 전송 계층

이 입문 과정에서는 서버가 제공하는 대표 기능을 세 가지로 나눕니다.

| 구분 | 클라이언트 관점 | 서버 구현 시 질문 |
|------|-----------------|-------------------|
| **Resources** | “URI로 **읽을 수 있는** 내용이 있나?” | 어떤 데이터를 **읽기 전용**으로 줄 것인가? |
| **Tools** | “모델이 **실행을 요청**할 수 있는 동작이 있나?” | 어떤 함수를 **부작용 가능**한 도구로 노출할 것인가? |
| **Prompts** | “미리 정의된 **프롬프트 조각**이 있나?” | 어떤 시나리오를 **템플릿+인자**로 재사용할 것인가? |

> 이 위에 **전송(transport)** 이 있습니다. 로컬 개발에서는 보통 **stdio**(표준 입출력)로 자식 프로세스로 서버를 띄우고, 파이프로 JSON-RPC 메시지를 주고받습니다.

---
## FastMCP의 역할

FastMCP는 Python에서 `FastMCP` 인스턴스를 만들고, 데코레이터로 함수를 등록하면 **MCP 스키마·라우팅**을 대신 맞춰 주는 SDK입니다.

- `@mcp.resource("uri://...")` → Resources
- `@mcp.tool` → Tools
- `@mcp.prompt` → Prompts
- `mcp.run()` → 기본적으로 stdio 등으로 서버 기동
