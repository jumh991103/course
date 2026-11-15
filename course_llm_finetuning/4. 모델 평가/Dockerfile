# ==================================================
# Base Image (CPU Runtime)
# ==================================================
# RTX 4090 업그레이드 또는 RTX 5090 출시 시 CUDA 12.8.1로 업그레이드 필요
# FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
# CUDA 12.1.1로 업그레이드 (RTX 4090 지원)
FROM runpod/pytorch:2.1.1-py3.10-cuda12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    CUDA_HOME=/usr/local/cuda \
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
# 3. DeepEval & QA 평가용 Libraries
# ==================================================
COPY requirements.txt /workspace/requirements.txt

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install torch==2.1.1+cu121 torchvision torchaudio \
    --extra-index-url https://download.pytorch.org/whl/cu121 \
    --force-reinstall
RUN python -m pip install --no-cache-dir \
    -r /workspace/requirements.txt

# 커널 등록 (--sys-prefix로 Python 환경 내에 설치)
RUN python -m ipykernel install --sys-prefix --name DeepEval --display-name "Python (DeepEval)"

# ==================================================
# 4. VSCode Server (선택)
# ==================================================

RUN curl -fsSL https://code-server.dev/install.sh | sh

# ==================================================
# 5. Workspace Content
# ==================================================
COPY lectures/ /opt/lectures/

EXPOSE 8080

CMD ["bash", "-c", "\
if [ ! -d /workspace/lectures ]; then cp -r /opt/lectures /workspace/lectures; fi && \
code-server /workspace \
    --bind-addr 0.0.0.0:8080 \
    --auth none \
    --disable-telemetry \
"]
