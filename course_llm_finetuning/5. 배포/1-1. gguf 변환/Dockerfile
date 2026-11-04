# ==================================================
# Base Image (CPU Runtime)
# ==================================================
FROM runpod/base:1.0.2-ubuntu2204

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /workspace

# ===============================
# System packages (OS pin)
# ===============================
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    python3.11 \
    python3-pip \
    python3.11-dev \
    wget \
    curl \
    libcurl4-openssl-dev \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

# ===============================
# llama.cpp (latest stable)
# ===============================
RUN git clone https://github.com/ggerganov/llama.cpp.git /opt/llama.cpp
WORKDIR /opt/llama.cpp

RUN cmake -B build \
    && cmake --build build --config Release

# ===============================
# Python GGUF stack (version pin)
# ===============================
COPY requirements.txt /workspace/requirements.txt

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --no-cache-dir \
    -r /workspace/requirements.txt

# ===============================
# Jupyter kernel ONLY (server 실행 안 함)
# ===============================
RUN python -m ipykernel install \
    --name llama-cpp \
    --display-name "Python (llama.cpp)"

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
    --install-extension ms-toolsai.jupyter

# ===============================
# Runtime cache (Volume friendly)
# ===============================
ENV XDG_DATA_HOME=/workspace/.vscode
ENV XDG_CONFIG_HOME=/workspace/.config
ENV XDG_CACHE_HOME=/workspace/.cache

# ===============================
# Permissions
# ===============================
RUN chmod -R 777 /workspace

# ===============================
# Expose VSCode Server
# ===============================
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

