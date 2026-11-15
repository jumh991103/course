FROM ollama/ollama:0.11.6

WORKDIR /

# Install Python (base image does not include it)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip ca-certificates && \
    rm -rf /var/lib/apt/lists/*


# Build-time model to download.
# - 예: --build-arg OLLAMA_MODEL="gemma3:4b"
ARG OLLAMA_MODEL="gemma3:4b"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

# Download Ollama model(s) during image build.
# `ollama pull`은 현재 `ollama serve`가 실행 중일 때만 동작하는 제약이 있어
# 빌드 중 임시로 서버를 띄운 뒤 모델을 받습니다.
COPY download_ollama_models.sh /download_ollama_models.sh
RUN sed -i 's/\r$//' /download_ollama_models.sh && chmod +x /download_ollama_models.sh && sh /download_ollama_models.sh

# Copy your handler file
COPY handler.py /
COPY test_input.json /
# Install dependencies
COPY requirements.txt /requirements.txt
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    -r /requirements.txt

# Start the container
# Base image has ENTRYPOINT ["ollama"], so override it.
ENTRYPOINT ["python3", "-u", "/handler.py"]