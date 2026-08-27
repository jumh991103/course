FROM python:3.13-slim

RUN apt update && \
    apt install -y nginx && \
    apt install -y default-libmysqlclient-dev build-essential pkg-config

# uv 바이너리를 공식 이미지에서 그대로 복사
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

WORKDIR /app

# 의존성 정의 파일만 먼저 복사해 uv sync 레이어를 캐싱
COPY ./django_server/pyproject.toml ./django_server/uv.lock ./
RUN uv sync --frozen

# 나머지 소스 복사 (.venv, db.sqlite3 등은 .dockerignore로 제외됨)
COPY ./django_server /app
COPY ./nginx_server/default.conf /etc/nginx/conf.d/default.conf

# uv가 만든 가상환경의 python/gunicorn을 기본 PATH로 사용
ENV PATH="/app/.venv/bin:$PATH"

ENV SECRET_KEY='django-insecure-jbkd@l(3$6@ph&bprwp#c#rnkhg0$ci1_&3nuwl#m!bce9o%nc'

COPY ./run.sh /app/run.sh
RUN sed -i 's/\r$//' /app/run.sh \
    && chmod +x /app/run.sh
CMD ["/app/run.sh"]
