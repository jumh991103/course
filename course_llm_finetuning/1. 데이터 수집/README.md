# 유튜브 자막 수집 (YouTube Caption Collector)

LLM Fine-tuning을 위한 육아/소아과 관련 YouTube 동영상 자막 데이터 수집 도구입니다.

---

## 프로젝트 개요

YouTube 플레이리스트에서 동영상 메타정보와 한국어 자막(caption)을 자동으로 수집하여 CSV로 저장합니다.  
수집된 데이터는 이후 Fine-tuning 학습 데이터로 활용됩니다.

```
YouTube 플레이리스트 URL
        │
        ▼
 동영상 URL 목록 수집 (pytube)
        │
        ▼
 동영상별 메타정보 + 자막 추출 (yt-dlp + youtube-transcript-api)
        │
        ▼
    CSV 파일 저장 (download/)
```

---

## 폴더 구조

```
.
├── common/
│   ├── utils.py                  # 공통 유틸리티 (폴더 생성 등)
│   └── youtube/
│       ├── download.py           # 플레이리스트 단위 수집 메인 로직
│       └── youtube_info.py       # YouTube URL·메타정보·자막 추출
├── download/                     # 수집된 CSV 파일 저장 위치
│   ├── 성장.csv
│   ├── 수면.csv
│   └── ...
├── 유튜브 자막 수집.ipynb          # 수집 실행 노트북
└── requirements.txt
```

---

## 수집 데이터 카테고리

소아청소년과 전문 채널(**하정훈의 삐뽀삐뽀 119 소아과**)의 플레이리스트를 대상으로 합니다.

| 카테고리 | 설명 |
|----------|------|
| 성장     | 아이 몸무게·키 성장 관련 |
| 수면     | 신생아·영아 수면 교육 |
| 모유     | 모유 수유 관련 정보 |
| 이유식   | 이유식 시작·진행 방법 |
| 영양     | 영양 섭취·식단 관련 |
| 신생아   | 신생아 케어 전반 |
| 질병     | 소아 질병 정보 |
| 예방접종 | 접종 일정·종류 안내 |
| 안전     | 영유아 안전사고 예방 |
| 임신     | 임신 중 주의사항 |
| 코로나   | 소아 코로나 관련 정보 |
| 훈육     | 아이 훈육·발달 |
| 육아     | 육아 전반 팁 |

---

## 설치 방법

```bash
# 가상환경 생성 및 활성화
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# 패키지 설치
pip install -r requirements.txt
```

---

## 사용 방법

`유튜브 자막 수집.ipynb`를 Jupyter에서 열어 실행합니다.

### 1. 수집할 플레이리스트 설정

```python
playlist_urls = [
    {
        "playlist_title": "성장",
        "url": "https://www.youtube.com/watch?v=...&list=..."
    },
    {
        "playlist_title": "수면",
        "url": "https://www.youtube.com/watch?v=...&list=..."
    },
    # 필요한 카테고리 추가
]
```

### 2. 수집 실행

```python
from common.youtube.download import main

main(playlist_urls)
```

### 3. 결과 확인

```python
import pandas as pd

df = pd.read_csv("./download/성장.csv")
df.head()
```

---

## 출력 형식

수집 결과는 `download/{playlist_title}.csv` 형식으로 저장됩니다.

| 컬럼 | 설명 |
|------|------|
| `video_url`  | YouTube 동영상 URL |
| `video_id`   | YouTube 동영상 ID |
| `title`      | 동영상 제목 |
| `channel`    | 채널명 |
| `caption`    | 한국어 자막 전체 텍스트 (공백으로 이어붙인 형태) |

---

## 주요 의존성

| 패키지 | 역할 |
|--------|------|
| `yt-dlp` | 동영상 메타정보 추출 |
| `pytube` | 플레이리스트 내 동영상 URL 목록 수집 |
| `youtube-transcript-api` | 한국어 자막 텍스트 추출 |
| `pandas` | 데이터 저장·처리 |
| `tqdm` | 수집 진행률 표시 |

---

## 참고 사항

- 자막이 없는 동영상은 자동으로 건너뜁니다.
- 요청 간 0.1초 딜레이를 적용하여 YouTube 서버 부하를 방지합니다.
- 한국어(`ko`, `ko-KR`) 자막만 수집 대상으로 합니다.
