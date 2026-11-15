## RunPod 강의자료 (기초 · 사용 · 서빙)

이 저장소는 RunPod을 활용해 **클라우드 GPU/Pods 기본 개념(기초)** 을 익히고, **Pod를 실제로 사용(접속/스토리지/템플릿)** 한 뒤, 마지막으로 **Serverless로 LLM 서빙(Ollama / vLLM)** 까지 실습하는 강의자료입니다.  
각 파트는 **문서(슬라이드/가이드)** 와 **실습 코드(`Dockerfile`, `handler.py`, `requirements.txt`, `test_input.json`)** 로 구성되어, 순서대로 따라 하면 전체 흐름을 완성할 수 있습니다.

---

## 대상

- RunPod을 처음 써보지만, 템플릿으로 개발 환경을 만들고 GPU를 써보고 싶은 분
- Docker 기반으로 서빙용 컨테이너 이미지를 만들고 배포해보고 싶은 분
- Serverless에서 Flex / Active Workers 차이와 Cold Start를 이해하고 싶은 분
- vLLM으로 OpenAI 호환 API 형태의 추론 서빙을 빠르게 구성해보고 싶은 분

---

## 준비물

- RunPod 계정 (Console 접근)
- Docker 설치 및 Docker Hub 로그인 가능 환경
- (선택) Hugging Face 토큰 (`HF_TOKEN`) — vLLM 예제에서 사용할 수 있음
- 과금 주의: GPU/Serverless 사용에 따라 비용이 발생할 수 있으니 공식 요금표를 기준으로 확인하세요.

---

## 폴더 구성

### `1. RunPod 기초/`

클라우드 GPU와 RunPod의 기본 개념, 그리고 **GPU Pod를 선택/실행/중지/삭제**하는 핵심 흐름을 다룹니다.

- `1. RunPod란.md`: 클라우드 GPU 개념, RunPod 장점, 요금 개념/절약 팁
- `2. RunPod실행.md`: Pods 화면/옵션(Secure/Community, Region, Volume, VRAM, Availability) 이해 + Pod 실행/종료 절차

### `2. RunPod 사용/`

실제로 Pod를 운영하면서 자주 쓰는 기능들(접속/스토리지/템플릿)을 실습합니다.

#### `2. RunPod 사용/1. Connect to Pods/`

Pod에 접속하는 방법(웹 터미널, JupyterLab 등)을 정리합니다.

- `1. Connect.md`: 접속 방식 비교 + Web Terminal/JupyterLab 접속 흐름
- `2. Connect by SSH.md`: SSH 접속 실습(환경 구성/키 등)

#### `2. RunPod 사용/2. Storage/`

RunPod 스토리지 종류와 데이터 유지/과금 차이를 실습 중심으로 이해합니다.

- `1. Storage.md`: Container/Volume/Network Volume 비교, 과금 주의점, 데이터 유지 실습
- `2. Network Volume.md`: Network Volume 생성/연결 및 활용

#### `2. RunPod 사용/3. Templates/`

RunPod에서 Pod를 쉽게 띄우기 위한 **Template 개념**을 이해하고, Docker Hub 이미지를 기반으로 **나만의 Template을 생성/적용**하는 실습입니다.

- 문서(슬라이드): `1. Templates.md`  
  - 템플릿 개념/종류(Official/Community/Custom) + 설정 항목(Container Image/Storage/Network/Env/Startup) 이해
- 문서(슬라이드): `2. Docker Template.md`  
  - Docker 로그인 → 이미지 빌드/푸시 → RunPod Template 생성 → GPU Pod 배포 → VSCode Server 접속 흐름
- 실습 노트북: `lectures/Runpod Template.ipynb`  
  - 템플릿 개념 정리 + 환경 확인(예: PyTorch/CUDA 체크)

### `3. RunPod 서빙/1. Serverless/`

RunPod **Serverless 개요**와 **Flex Workers 예제(Ollama)** 를 따라 하며, 컨테이너 기반 서빙을 구성합니다.

- 문서(슬라이드): `Serverless.md`  
  - Flex vs Active 개념/요금/특징  
  - 예제: Flex Workers with Ollama  
  - Docker 빌드/테스트 → Docker Hub 배포 → Serverless Endpoint 생성/테스트
- 실습 코드: `Dockerfile`, `handler.py`, `requirements.txt`, `test_input.json`, `download_ollama_models.sh`

### `3. RunPod 서빙/2. vLLM/`

vLLM의 핵심 개념과 장점을 이해하고, RunPod Serverless에서 **vLLM 기반 서빙(Active Workers)** 을 구성합니다.  
특히 **Cold Start 문제**와 이를 완화하기 위한 설정 포인트를 다룹니다.

- 문서(슬라이드): `vLLM.md`  
  - vLLM 개요(PagedAttention, Continuous Batching, OpenAI 호환 API)  
  - Cold Start가 발생하는 이유와 실서비스 이슈  
  - 해결책: Active Workers  
  - 예제: Active Workers with vLLM
- 실습 코드: `Dockerfile`, `handler.py`, `requirements.txt`, `test_input.json`

---

## 권장 학습 순서

아래 순서는 **문서가 누락되지 않도록** “필수 → 심화(선택)”까지 포함해 정리했습니다.

1. RunPod 기초
   - (필수) `1. RunPod 기초/1. RunPod란.md`
   - (필수) `1. RunPod 기초/2. RunPod실행.md`
2. RunPod 사용: Pod 접속
   - (필수) `2. RunPod 사용/1. Connect to Pods/1. Connect.md`
   - (선택) `2. RunPod 사용/1. Connect to Pods/2. Connect by SSH.md`
3. RunPod 사용: 스토리지
   - (필수) `2. RunPod 사용/2. Storage/1. Storage.md`
   - (선택) `2. RunPod 사용/2. Storage/2. Network Volume.md`
4. RunPod 사용: 템플릿
   - (필수) `2. RunPod 사용/3. Templates/1. Templates.md`
   - (필수) `2. RunPod 사용/3. Templates/2. Docker Template.md`
   - (선택) `2. RunPod 사용/3. Templates/lectures/Runpod Template.ipynb`
   - (참고) `2. RunPod 사용/3. Templates/Dockerfile`
5. RunPod 서빙: Serverless(Flex Workers, Ollama)
   - (필수) `3. RunPod 서빙/1. Serverless/Serverless.md`
6. RunPod 서빙: vLLM(Active Workers)
   - (필수) `3. RunPod 서빙/2. vLLM/vLLM.md`

---

## 로컬 실습 공통 흐름 (요약)

각 실습 폴더로 이동해 진행합니다.

### Docker 이미지 빌드

```bash
docker build --platform linux/amd64 -t [YOUR_USERNAME]/[IMAGE_NAME]:latest .
```

### 컨테이너 실행/테스트

```bash
docker run -it [YOUR_USERNAME]/[IMAGE_NAME]:latest
```

> 폴더별 `test_input.json`을 활용한 테스트는 해당 문서(`Serverless.md`, `vLLM.md`) 흐름을 따릅니다.

### Docker Hub 푸시

```bash
docker push [YOUR_USERNAME]/[IMAGE_NAME]:latest
```

---

## 참고 링크

- RunPod Templates: https://docs.runpod.io/pods/templates/overview
- RunPod Serverless: https://docs.runpod.io/serverless/overview
- RunPod Serverless Pricing: https://docs.runpod.io/serverless/pricing
- vLLM: https://docs.vllm.ai/en/latest/

---

## 라이선스 / 사용 안내

본 저장소는 교육 목적의 강의자료 및 예제 코드로 구성되어 있습니다.  
재배포/활용 범위는 강의 운영 정책(또는 저작권 정책)에 따르세요.
