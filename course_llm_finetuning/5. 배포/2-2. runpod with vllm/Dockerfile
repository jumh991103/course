# vLLM + Hugging Face (Hub에서 MODEL_NAME으로 가중치 로드)
# 베이스 이미지에 CUDA·vLLM이 포함되어 있음 → 핸들러만 추가
# vLLM 0.8.5 는 Gemma3(gemma3_text)를 네이티브로 지원합니다.
FROM vllm/vllm-openai:v0.8.5

# transformers 는 vLLM 번들 버전 그대로 유지 (재설치하면 내부 API 충돌)
# huggingface_hub 와 accelerate 만 별도 추가/업그레이드
RUN pip install --no-cache-dir \
    "huggingface_hub>=0.28.1" \
    "accelerate>=1.6.0"

WORKDIR /

ENV PYTHONUNBUFFERED=1
# vLLM V1 엔진 비활성화 → V0(레거시) 엔진 사용 (파인튜닝 모델 안정성)
ENV VLLM_USE_V1=0
# 배포 시 RunPod 엔드포인트 환경 변수로 덮어쓰기 (예: Qwen/Qwen2.5-0.5B-Instruct)
ENV MODEL_NAME=good593/unsloth-gemma3-1b-finetune-diseases

COPY requirements.txt .
# (pip already upgraded above)
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .
COPY test_input.json /test_input.json

# OpenAI 서버 기본 진입점 대신 RunPod Serverless 핸들러 실행
ENTRYPOINT []
CMD ["python3", "-u", "/handler.py"]
