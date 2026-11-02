# vLLM + Hugging Face (Hub에서 MODEL_NAME으로 가중치 로드)
# 베이스 이미지에 CUDA·vLLM이 포함되어 있음 → 핸들러만 추가
FROM vllm/vllm-openai:v0.8.5

WORKDIR /

ENV PYTHONUNBUFFERED=1
# 배포 시 RunPod 엔드포인트 환경 변수로 덮어쓰기 (예: Qwen/Qwen2.5-0.5B-Instruct)
ENV MODEL_NAME=Qwen/Qwen2.5-0.5B-Instruct

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .
COPY test_input.json /test_input.json

# OpenAI 서버 기본 진입점 대신 RunPod Serverless 핸들러 실행
ENTRYPOINT []
CMD ["python3", "-u", "/handler.py"]
