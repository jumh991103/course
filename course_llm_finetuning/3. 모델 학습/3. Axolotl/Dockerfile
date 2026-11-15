# ==================================================
# Base Image (CUDA + cuDNN pin)
# ==================================================
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV CUDA_HOME=/usr/local/cuda
ENV TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0"

WORKDIR /workspace

# ==================================================
# System packages
# ==================================================
RUN apt-get update && apt-get install -y \
    git=1:2.34.* \
    curl \
    wget \
    vim \
    build-essential \
    ninja-build \
    libaio-dev \
    python3.11 \
    python3-pip \
    python3.11-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

# ==================================================
# Python base
# ==================================================
RUN pip install --upgrade \
    pip==24.0 \
    setuptools==69.5.1 \
    wheel==0.43.0

# ==================================================
# PyTorch (CUDA 12.1 공식 wheel)
# ==================================================
RUN pip install \
    torch==2.8.0 \
    torchvision==0.23.0 \
    torchaudio==2.8.0 \
    --index-url https://download.pytorch.org/whl/cu128

# ==================================================
# Core HF stack (Axolotl 검증 조합)
# ==================================================
RUN pip install \
    transformers==4.40.2 \
    accelerate==0.30.1 \
    datasets==2.19.0 \
    sentencepiece==0.1.99 \
    protobuf==4.25.3 \
    scipy==1.11.4 \
    einops==0.7.0 \
    pydantic==2.7.1 \
    packaging==24.0 \
    safetensors==0.4.3

# ==================================================
# Axolotl + Training stack (핵심)
# ==================================================
RUN pip install \
    peft==0.13.2 \
    trl==0.12.0 \
    bitsandbytes==0.44.1 \
    deepspeed==0.14.2 \
    axolotl==0.5.0

# ==================================================
# Optional (강의/실험 편의)
# ==================================================
RUN pip install \
    wandb==0.17.0 \
    tensorboard==2.16.2 \
    rich==13.7.1

# ==================================================
# Jupyter kernel ONLY (server는 실행 안 함)
# ==================================================
RUN pip install \
    ipykernel==6.29.4 \
    jupyter-client==8.6.1 \
    nbformat==5.10.4

# Python 커널 등록
RUN python -m ipykernel install \
    --name axolotl \
    --display-name "Python (Axolotl)"

# ==================================================
# VSCode Server (code-server)
# ==================================================
ENV HOME=/root

RUN curl -fsSL https://code-server.dev/install.sh | sh \
    && /usr/bin/code-server --version

# ==================================================
# VSCode extensions (강의 필수)
# ==================================================
RUN /usr/bin/code-server \
    --install-extension ms-python.python \
    --install-extension ms-toolsai.jupyter \
    --install-extension ms-python.vscode-pylance

# ==================================================
# Runtime cache locations (RunPod Volume friendly)
# ==================================================
ENV HF_HOME=/workspace/.cache/huggingface
ENV TRANSFORMERS_CACHE=/workspace/.cache/huggingface
ENV WANDB_DIR=/workspace/.cache/wandb

ENV XDG_DATA_HOME=/workspace/.vscode
ENV XDG_CONFIG_HOME=/workspace/.config
ENV XDG_CACHE_HOME=/workspace/.cache

# ==================================================
# Permissions
# ==================================================
RUN chmod -R 777 /workspace

# ==================================================
# Expose VSCode Server
# ==================================================
EXPOSE 8080

# ==================================================
# 강의자료 복사
# ==================================================
COPY lectures/ /opt/lectures/

# ==================================================
# Entrypoint
# ==================================================
CMD ["bash", "-c", "\
if [ ! -d /workspace/lectures ]; then \
  cp -r /opt/lectures /workspace/lectures; \
fi && \
code-server /workspace \
  --bind-addr 0.0.0.0:8080 \
  --auth none \
  --disable-telemetry \
"]
