# AI 보안 및 가드레일 설계

LangGraph를 이용해 멀티 에이전트 시스템의 보안 경계를 설계하는 커리큘럼입니다. 핵심 주제는 **Agent별 권한 분리**, **Capability 설계**, **Agent 간 메시지 검증**입니다.

## 학습 목표

- 에이전트 보안을 프롬프트 규칙이 아니라 런타임 정책과 그래프 제어 흐름으로 설계한다.
- Agent별 권한, 도구, 데이터 접근 범위를 분리하고 `default deny` 원칙을 적용한다.
- Capability를 `누가`, `무엇을`, `어떤 목적과 조건에서`, `어떤 감사 기록과 함께` 실행할 수 있는지로 모델링한다.
- Agent 간 메시지를 신뢰하지 않는 입력으로 보고 스키마, 송수신 경로, Capability, 민감도 기준으로 검증한다.
- 차단, 승인, 사람 검토, 감사 로그를 LangGraph 상태 전이로 구현한다.

## 폴더 구성

| 파일 | 주제 | 결과물 |
| --- | --- | --- |
| `1. Agent Security Threat Modeling (기초).ipynb` | 멀티 에이전트 위협 모델링과 보안 라우팅 | 위험 탐지 후 허용/차단/검토로 분기하는 LangGraph |
| `2. Agent Permission Separation (중급).ipynb` | Agent별 권한 분리와 도구 실행 통제 | Agent별 allowlist 기반 도구 호출 래퍼 |
| `3. Capability Design (중급).ipynb` | Capability 카탈로그와 정책 엔진 | Capability 승인/거절/사람 검토 그래프 |
| `4. Inter-Agent Message Validation (고급).ipynb` | Agent 간 메시지 검증 | 메시지 envelope 검증, 경로 검증, 감사 로그 |
| `requirements.txt` | 실습 환경 | LangGraph와 검증 라이브러리 |

## 사전 준비

이 단원은 `2. LangGraph`의 기본 그래프, 노드, 조건부 라우팅을 학습한 뒤 진행하는 것을 권장합니다. 모든 실습은 외부 LLM API 없이 실행되는 보안 시뮬레이션으로 구성되어 있습니다.

```powershell
cd "7. AI 보안 및 가드레일 설계"
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook
```

## 커리큘럼 흐름

| 차시 | 핵심 질문 | 주요 개념 | 실습 |
| --- | --- | --- | --- |
| 1차시 | 에이전트 시스템에서 무엇을 막아야 하는가? | Prompt Injection, Tool Abuse, Data Exfiltration, Confused Deputy | 입력 위험 신호를 탐지하고 LangGraph에서 차단 경로로 라우팅 |
| 2차시 | Agent가 자기 역할 밖의 도구를 호출하지 못하게 하려면? | Least Privilege, Role Boundary, Tool Allowlist | Agent별 Capability allowlist와 도구 실행 래퍼 구현 |
| 3차시 | Capability를 코드로 어떻게 표현할 것인가? | Capability Registry, Purpose Binding, Human Approval, Sensitivity | 정책 엔진이 승인/거절/사람 검토를 결정 |
| 4차시 | Agent가 Agent에게 보내는 메시지는 믿어도 되는가? | Message Envelope, Schema Validation, Edge Policy, Audit Trace | Pydantic 스키마와 LangGraph 검증 노드로 메시지 전달 보호 |

## 설계 원칙

1. **프롬프트는 보안 경계가 아니다.** 보안 규칙은 코드, 정책, 상태 전이, 도구 래퍼에서 강제한다.
2. **권한은 Agent 단위로 분리한다.** Supervisor가 시킨 일이라도 하위 Agent의 권한 밖이면 실행하지 않는다.
3. **Capability는 도구 이름보다 구체적이어야 한다.** `finance.refund.draft`, `hr.salary.read`처럼 리소스와 행위를 함께 표현한다.
4. **Agent 간 메시지는 검증 대상이다.** 송신자, 수신자, intent, capability, payload, sensitivity를 모두 확인한다.
5. **감사 로그는 상태의 일부다.** 승인, 거절, 우회 시도, 사람 검토 요청은 traceable해야 한다.

## 수업 운영안

### 1차시: 위협 모델링과 보안 라우팅

- 위협 시나리오를 먼저 만든다.
- 위험 신호를 `signals`로 상태에 기록한다.
- 위험도가 높으면 업무 Agent에 도달하기 전에 차단한다.
- 결과: 보안 라우터가 포함된 최소 LangGraph를 완성한다.

### 2차시: Agent별 권한 분리

- Agent와 도구를 먼저 나누고, 권한 테이블을 별도로 둔다.
- 도구 함수 내부가 아니라 공통 `call_tool` 래퍼에서 권한을 확인한다.
- Confused Deputy 공격을 재현하고 차단 결과를 확인한다.
- 결과: Agent별 allowlist와 실행 감사 로그를 완성한다.

### 3차시: Capability 설계

- Capability를 `id`, `owner_agent`, `resource`, `action`, `sensitivity`, `allowed_purposes`, `requires_human`으로 정의한다.
- 요청 목적과 사용자 역할을 함께 검증한다.
- 민감하거나 되돌릴 수 없는 행위는 사람 검토로 보낸다.
- 결과: 재사용 가능한 Capability 정책 엔진을 완성한다.

### 4차시: Agent 간 메시지 검증

- Agent 간 메시지를 envelope 구조로 표준화한다.
- 스키마 검증과 정책 검증을 분리한다.
- 허용된 edge가 아닌 메시지, Capability mismatch, 민감도 위반을 차단한다.
- 결과: 메시지 검증 노드와 감사 로그를 갖춘 전달 그래프를 완성한다.

## 미니 프로젝트

다음 요구사항을 만족하는 보안형 멀티 에이전트 워크플로우를 설계합니다.

- 최소 4개 Agent: `intake`, `research`, `finance`, `security`
- 최소 6개 Capability
- Agent별 허용 Capability 목록
- 메시지 envelope 스키마
- 차단, 승인, 사람 검토 경로
- 모든 정책 판단에 대한 감사 로그

## 평가 기준

| 항목 | 기준 |
| --- | --- |
| 권한 분리 | Agent별 도구 호출 범위가 코드로 강제되는가 |
| Capability 모델 | 리소스, 행위, 목적, 민감도, 사람 검토 조건이 표현되는가 |
| 메시지 검증 | 스키마와 송수신 경로 정책이 모두 적용되는가 |
| LangGraph 활용 | 보안 판단이 명시적인 노드와 조건부 edge로 구현되는가 |
| 감사 가능성 | 승인/거절/검토 사유가 상태와 로그에 남는가 |

## 토론 질문

- Supervisor가 하위 Agent에게 권한 밖의 일을 시키면 누구의 책임으로 차단해야 하는가?
- Capability를 너무 잘게 쪼개면 운영 복잡도가 어떻게 변하는가?
- 메시지 검증을 중앙 집중식으로 할 때와 각 Agent 앞단에서 할 때의 차이는 무엇인가?
- 사람 검토가 필요한 기준은 위험도, 금액, 데이터 민감도 중 어디에 두는 것이 좋은가?
