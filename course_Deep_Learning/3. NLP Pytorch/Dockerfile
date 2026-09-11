# 1. 베이스 이미지
FROM ubuntu:22.04

# 2. 환경 변수 설정
ENV TZ=Asia/Seoul
ENV DEBIAN_FRONTEND=noninteractive

# 3. 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    g++ \
    openjdk-8-jdk \
    python3 python3-pip python3-venv \
    build-essential \
    locales \
    cmake automake autoconf libtool pkg-config \
    curl \
    wget \
    git \
    lsof \
    && rm -rf /var/lib/apt/lists/*

# 4. 작업 디렉토리 설정
WORKDIR /workspace

# 5. requirements.txt 복사 및 라이브러리 설치
RUN pip3 install numpy==1.26.4
COPY requirements.txt /workspace/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# 6. 컨테이너 실행 시 JupyterLab 실행
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
