# 1. 베이스 이미지
FROM ubuntu:22.04

# uv 바이너리는 공식 이미지에서 가져옵니다.
COPY --from=ghcr.io/astral-sh/uv:0.12.12 /uv /uvx /bin/

# 2. 환경 변수 설정
ENV TZ=Asia/Seoul
ENV DEBIAN_FRONTEND=noninteractive

# 3. 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    g++ \
    openjdk-8-jdk \
    python3 \
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

# 5. uv lock 파일을 사용해 가상환경과 라이브러리 설치
# /workspace는 docker-compose에서 바인드 마운트되므로 프로젝트 환경은 /opt에 둡니다.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv
ENV VIRTUAL_ENV=${UV_PROJECT_ENVIRONMENT}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

COPY pyproject.toml uv.lock /workspace/
#RUN uv sync --locked --no-dev --no-cache
RUN uv sync

# 6. 컨테이너 실행 시 JupyterLab 실행
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
