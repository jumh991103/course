# ==================================================
# 1. Base Image
# ==================================================
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    CUDA_HOME=/usr/local/cuda \
    # 파이썬 실행 경로를 명시적으로 설정
    PYTHON_EXE=/usr/bin/python3.11 

WORKDIR /workspace

# ==================================================
# 2. System Packages & Python Link
# ==================================================
RUN apt-get update && apt-get install -y \
    git curl wget vim build-essential \
    python3.11 python3.11-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 시스템 기본 파이썬 3.11로 고정
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.11 /usr/bin/python && \
    python -m pip install --upgrade pip setuptools wheel

# ==================================================
# 3. AI Libraries (명시적 파이썬 호출)
# ==================================================
COPY requirements.txt /workspace/requirements.txt

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --no-cache-dir \
    -r /workspace/requirements.txt

# 커널 등록 시에도 정확한 경로 지정
RUN /usr/bin/python3.11 -m ipykernel install --name unsloth --display-name "Python (Unsloth)"

# ==================================================
# 4. VSCode Server
# ==================================================
RUN curl -fsSL https://code-server.dev/install.sh | sh

# ==================================================
# 5. Environment & Content
# ==================================================
ENV HF_HOME=/workspace/.cache/huggingface \
    XDG_DATA_HOME=/workspace/.vscode

COPY lectures/ /opt/lectures/

EXPOSE 8080

CMD ["bash", "-c", "\
if [ ! -d /workspace/lectures ]; then cp -r /opt/lectures /workspace/lectures; fi && \
code-server /workspace \
    --bind-addr 0.0.0.0:8080 \
    --auth none \
    --disable-telemetry \
"]
