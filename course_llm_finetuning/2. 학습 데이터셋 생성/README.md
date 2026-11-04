# 학습 데이터셋 생성

LLM Fine-Tuning에 사용할 **영양** 및 **질병** 분야의 학습 데이터셋을 생성하는 파이프라인입니다.  
소아청소년과 전문의의 유튜브 영상 캡션을 원본 데이터로 하여, LLM으로 정제하고 RAGAs로 질문-답변 쌍을 자동 생성한 뒤 Hugging Face에 업로드합니다.

---

## 전체 파이프라인

```
유튜브 캡션 CSV               클린징 CSV              학습 데이터셋 CSV         Hugging Face
─────────────────────────────────────────────────────────────────────────────────────
data/download/영양.csv   →   data/cleaning/nutrition.csv   →   data/training/nutrition.csv   →   good593/nutrition-dataset
data/download/질병.csv   →   data/cleaning/illnesses.csv   →   data/training/illnesses.csv   →   good593/illnesses-dataset
                          ↑                              ↑                               ↑
                       Step 1                         Step 2                          Step 3
                    (클린징 노트북)            (데이터셋 생성 노트북)           (허깅페이스 업로드 노트북)
```

---

## 파일 구조

```
.
├── .env.sample                          # 환경변수 샘플 파일
├── requirements.txt                     # 패키지 목록
│
├── 1-1. 영양 수집 데이터 클린징.ipynb      # Step 1: 영양 캡션 정제
├── 1-2. 영양 학습 데이터셋 생성.ipynb      # Step 2: 영양 질문-답변 쌍 생성 (RAGAs)
├── 1-3. 영양 학습 데이터셋 to 허깅페이스.ipynb  # Step 3: Hugging Face 업로드
│
├── 2-1. 질병 수집 데이터 클린징.ipynb      # Step 1: 질병 캡션 정제
├── 2-2. 질병 학습 데이터셋 생성.ipynb      # Step 2: 질병 질문-답변 쌍 생성 (RAGAs)
├── 2-3. 질병 학습 데이터셋 to 허깅페이스.ipynb  # Step 3: Hugging Face 업로드
│
└── data/
    ├── download/       # 원본 유튜브 캡션 CSV (영양.csv, 질병.csv)
    ├── cleaning/       # LLM으로 정제된 CSV (nutrition.csv, illnesses.csv)
    └── training/       # RAGAs로 생성된 최종 학습 데이터셋 (nutrition.csv, illnesses.csv)
```

---

## 환경 설정

### 1. 패키지 설치

```bash
pip install -r requirements.txt
```

### 2. 환경변수 설정

`.env.sample`을 복사하여 `.env` 파일을 생성하고 API 키를 입력합니다.

```bash
cp .env.sample .env
```

```ini
# .env
OPENAI_API_KEY="sk-..."        # OpenAI API 키
HF_TOKEN="hf_..."              # Hugging Face 토큰 (write 권한 필요)
```

- OpenAI API 키: https://platform.openai.com/settings/organization/api-keys
- Hugging Face 토큰: https://huggingface.co/settings/tokens

---

## 노트북 설명

### Step 1 — 수집 데이터 클린징 (1-1, 2-1)

유튜브 자동 생성 캡션은 오탈자, 반복 표현, 의미 없는 소리가 많아 그대로 사용하기 어렵습니다.  
두 단계로 정제합니다.

**① 규칙 기반 클린징**
- `[음악]`, `[박수]` 등 불필요한 태그 제거
- 중복 영상(video_id 기준) 제거
- 제목에서 번호(`#25`, `#164`) 및 고유명사 치환

**② LLM 기반 캡션 정제**
- 모델: `gpt-5-mini` (reasoning_effort="high")
- 프롬프트: 의미를 유지하면서 자연스러운 한국어로 복원
- 고유명사 치환 규칙 적용 (예: "삐뽀삐뽀119소아과" → "소아청소년과")
- 배치 크기 50, 최대 동시 요청 수는 OpenAI Tier에 따라 조정 (아래 [OpenAI API Rate Limit](#openai-api-rate-limit) 참고)

| 구분 | 원본 데이터 수 | 클린징 후 |
|------|-------------|---------|
| 영양 | 66개         | 65개    |
| 질병 | 130개        | 129개   |

**생성 컬럼**

| 컬럼명 | 설명 |
|--------|------|
| `video_url` | 유튜브 영상 URL |
| `title` | 정제된 영상 제목 |
| `clean_caption` | LLM으로 정제된 캡션 |
| `title_caption` | `[title] 제목 [caption] 캡션` 형식의 통합 텍스트 |

---

### Step 2 — 학습 데이터셋 생성 (1-2, 2-2)

**[RAGAs](https://docs.ragas.io/)** 라이브러리의 `TestsetGenerator`를 사용하여 질문-답변 쌍을 자동 생성합니다.

**사용 모델**
- 생성 LLM: `gpt-4o-mini` (질문 & 답변 생성)
- 임베딩 모델: `text-embedding-3-small` (문서 벡터화)

**페르소나 (Persona)**

다양한 질문 스타일을 확보하기 위해 3가지 페르소나를 정의합니다.

| 도메인 | 페르소나 |
|--------|---------|
| 영양 | a pediatric nutrition expert, a child nutrition specialist, a pediatrician |
| 질병 | a pediatrician, a compassionate pediatrician, a pediatric medical expert |

**주요 컴포넌트**

- `NERExtractor`: 문서에서 핵심 개체명(NER)을 추출하여 질문 생성에 활용
- `SingleHopSpecificQuerySynthesizer`: 단일 문서 기반 구체적 질문 자동 생성
- `adapt_prompts("korean", ...)`: 프롬프트를 한국어에 맞게 적응

**생성 결과**

| 구분 | 생성 목표 | 중복 제거 후 최종 |
|------|---------|----------------|
| 영양 | 200개    | 198개          |
| 질병 | 800개    | 793개          |

**최종 데이터셋 컬럼**

| 컬럼명 | 설명 |
|--------|------|
| `user_input` | 생성된 질문 |
| `reference` | 질문에 대한 참조 답변 |
| `reference_video_url` | 답변의 출처 유튜브 URL |
| `persona_name` | 질문을 생성한 페르소나 |
| `query_style` | 질문 스타일 (MISSPELLED / POOR_GRAMMAR / WEB_SEARCH_LIKE / PERFECT_GRAMMAR) |
| `query_length` | 질문 길이 (SHORT / MEDIUM / LONG) |

---

### Step 3 — Hugging Face 업로드 (1-3, 2-3)

HuggingFace `datasets` 라이브러리로 CSV를 `DatasetDict`로 변환하여 Hub에 업로드합니다.

```python
from datasets import load_dataset

csv_dataset = load_dataset("csv", data_files="./data/training/nutrition.csv")
csv_dataset.push_to_hub("your-id/dataset-name")
```

**업로드된 데이터셋**
- 영양: https://huggingface.co/datasets/good593/nutrition-dataset
- 질병: https://huggingface.co/datasets/good593/illnesses-dataset

---

## 핵심 개념 정리

### RAGAs TestsetGenerator

RAGAs는 RAG(Retrieval-Augmented Generation) 평가 프레임워크입니다.  
`TestsetGenerator`는 문서 컬렉션을 입력받아 다양한 스타일의 질문-답변 쌍을 자동으로 생성합니다.

```python
from ragas.testset import TestsetGenerator

generator = TestsetGenerator(
    llm=generator_llm,
    embedding_model=generator_embeddings,
    persona_list=personas  # 다양한 질문 스타일을 위한 페르소나 목록
)

dataset = generator.generate_with_langchain_docs(
    docs,
    testset_size=200,
    transforms=[NERExtractor(llm=generator_llm)],  # 개체명 추출 변환
    query_distribution=distribution,               # 질문 유형 분포
)
```

### LangChain Batch 처리

대량의 데이터를 LLM에 전달할 때 배치 처리와 동시 요청으로 처리 속도를 높입니다.

```python
results = chain.batch(
    inputs,                                    # 입력 리스트
    config={"max_concurrency": 8}             # 최대 동시 요청 수
)
```

**`chunks` 함수가 필요한 이유**

`chain.batch()`에 전체 리스트를 한 번에 넘기는 대신, `chunks`로 잘라서 배치 단위로 처리합니다.

```python
def chunks(lst, size):
    for i in range(0, len(lst), size):
        yield lst[i:i + size]

for chunk in tqdm(list(chunks(inputs, BATCH_SIZE))):
    results.extend(chain.batch(chunk, config={"max_concurrency": MAX_CONCURRENCY}))
```

| 이유 | 설명 |
|------|------|
| **메모리 절약** | 수백~수천 개를 한번에 올리면 메모리 부족 가능 |
| **API Rate Limit 대응** | 배치 크기를 조절해 분당 요청 수(RPM) 초과 방지 |
| **진행률 확인** | `tqdm`으로 배치 단위 진행상황을 실시간으로 확인 가능 |
| **부분 실패 대응** | 한 배치가 실패해도 이전 배치의 결과는 `results`에 보존됨 |

**`valid_mask` + `compress` 필터링이 필요한 이유**

LLM에 넘기기 전에 빈 값을 걸러내는 전처리 단계입니다.

```python
from itertools import compress

valid_mask = [isinstance(c, str) and c.strip() for c in captions]
inputs = [{"caption": caption} for caption in compress(captions, valid_mask)]
```

크롤링·파싱 과정에서 생긴 `None`, `NaN`, 공백만 있는 행을 제거합니다.  
이 값들을 그대로 API에 보내면 에러가 발생하거나 불필요한 비용이 소모됩니다.

### OpenAI API Rate Limit

OpenAI의 Rate Limit은 **IP 기준이 아닌 API Key 기준**으로 적용됩니다.  
반드시 본인의 API Key를 발급받아 사용해야 하며, Tier에 따라 허용 한도가 다릅니다.

| Tier | 조건 | RPM | TPM |
|------|------|-----|-----|
| Tier 1 | 첫 결제 $5 이상 | 500 | 200,000 |
| Tier 2 | 누적 결제 $50 이상 | 5,000 | 2,000,000 |

> RPM: Requests Per Minute / TPM: Tokens Per Minute

**`MAX_CONCURRENCY` 권장 설정**

캡션 1건당 약 1,500~2,500 tokens를 소비합니다.  
Tier 1의 TPM 한도(200,000)를 초과하지 않으려면 동시 요청 수를 제한해야 합니다.

```python
BATCH_SIZE = 50

# Tier 1 사용자
MAX_CONCURRENCY = 5   # 분당 약 120,000 tokens → Tier 1 한도 이내

# Tier 2 사용자
MAX_CONCURRENCY = 8   # 분당 약 190,000 tokens → Tier 2 한도 이내
```

- Tier 확인: https://platform.openai.com/settings/organization/limits

---

## 실행 순서

```
1-1 → 1-2 → 1-3   (영양 도메인)
2-1 → 2-2 → 2-3   (질병 도메인)
```

각 단계는 이전 단계의 출력 파일을 입력으로 사용하므로 순서대로 실행해야 합니다.
