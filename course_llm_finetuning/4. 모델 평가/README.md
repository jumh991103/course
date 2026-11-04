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
# Docker 

---
### 단계1: Docker Image 생성
```shell
docker build -t <Docker ID>/evaluation-deepeval-runpod:3.7.6 .
```
![alt text](./img/image.png)

---
> 결과확인

![alt text](./img/image-1.png)

---
### 단계2: Docker Container 실행 
```shell
# CPU용
docker run -it --rm -p 8080:8080 -v ./workspace:/workspace <Docker ID>/evaluation-deepeval-runpod:3.7.6
```
![alt text](./img/image-2.png)

---
> [결과확인](http://localhost:8080/?folder=/workspace)

![alt text](./img/image-3.png)

---
### 단계3: Docker Hub 배포 
```shell
docker push <Docker ID>/evaluation-deepeval-runpod:3.7.6
```
![alt text](./img/image-4.png)

---
> 결과확인

![alt text](./img/image-5.png)

---
# Runpod

---
### 단계1: GPU Pod
![alt text](./img/image-6.png)

---
### 단계2: Edit
![alt text](./img/image-7.png)

---
### 단계3: Docker Image 적용
![bg right w:600](./img/image-8.png)

---
### 단계4: GPU Pod 생성
![bg right w:600](./img/image-9.png)

---
### 단계5: GPU Pod 접속  
![bg right w:600](./img/image-10.png)

---
> 결과 확인 

![alt text](./img/image-11.png)


