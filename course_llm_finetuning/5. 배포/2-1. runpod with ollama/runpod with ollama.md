---
style: |
  img {
    display: block;
    float: none;
    margin-left: auto;
    margin-right: auto;
  }
marp: true
paginate: true
---
# Docker Hub에 이미지 배포하기

---
### 단계1: Docker Server 실행 및 로그인
![alt text](./img/image.png)

---
### 단계2: Docker Image 생성
```bash
# 도커파일이 있는 폴더에서 실행 
docker build --platform linux/amd64 -t [YOUR_USERNAME]/runpod-ollama:latest .
```
![alt text](./img/image-1.png)

---
> 결과 확인 

![alt text](./img/image-2.png)

---
### 단계3: Docker Hub 배포 
```shell
docker push [YOUR_USERNAME]/runpod-ollama:latest
```
![alt text](./img/image-3.png)

---
> [결과 확인](https://hub.docker.com/repository/docker/goodwon593/runpod-ollama/general)

![alt text](./img/image-4.png)

---
# [Runpod 배포](https://console.runpod.io/serverless)

---
### 단계1: Runpod > Serverless
![alt text](./img/image-5.png)

---
### 단계2: Create a new deployment
![alt text](./img/image-6.png)

---
> Container image

![alt text](./img/image-7.png)

---
> Worker type

![alt text](./img/image-8.png)

---
> Create endpoint

![alt text](./img/image-9.png)

---
### 단계3: Serverless 테스트
![alt text](./img/image-10.png)

---
> 허니 햄버거 병이란 무엇인가요?

![alt text](./img/image-11.png)

---
> 결과 확인 

![alt text](./img/image-12.png)
