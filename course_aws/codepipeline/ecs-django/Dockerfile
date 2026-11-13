FROM python:3.12-slim

RUN apt update && apt install nginx -y

# 파이썬 모듈 설치 
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Django server
COPY ./django-server /app
WORKDIR /app

# 환경변수 적용 
ENV SECRET_KEY 'django-insecure-ikcd15eh67@-xq2da&n2o1k)(bq6839ussi4-&ym=0nv4x(fyv'

COPY ./run.sh /app/run.sh
RUN sed -i 's/\r$//' /app/run.sh \
    && chmod +x /app/run.sh
CMD ["/app/run.sh"]

