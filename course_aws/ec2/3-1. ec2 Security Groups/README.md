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
# Security Group 확인

---
### 단계1: Instance의 Security Group 확인 
![alt text](./img/image.png)

---
### 단계2: Inbound rules 확인
- 외부에서 내부(ec2)에 접속할 수 있는 Rule 정의 

![alt text](./img/image-1.png)

---
### 단계3: Outbound rules 확인 
- 내부(ec2)에서 외부로 접속할 수 있는 Rule 정의

![alt text](./img/image-2.png)

---
# Nginx 접속 테스트 

---
### 단계1: ec2 접속
```shell
ssh hello-ec2
```
![alt text](./img/image6.png)

---
### 단계2: update
```shell
sudo apt-get update
```
![alt text](./img/image0.png)

---
### 단계3: install nginx
```shell
sudo apt-get install nginx -y
```
![alt text](./img/image1.png)

---
### 단계4: nginx server 실행 확인 
```shell
systemctl status nginx
```
![alt text](./img/image2.png)

---
### 단계5: Public IP 확인 
![alt text](./img/image3.png)

---
### 단계6: nginx 접속 실패 
- Public IP로 접속 시도 

![alt text](./img/image5.png)

---
### 단계7: Inbound rules 변경 
![alt text](./img/image-3.png)

---
- 예제: http 프로토콜 & Apache Tomcat Server 추가 
- Nginx Server Port: `80`

![alt text](./img/image-4.png)

---
- 변경 내용 확인 

![alt text](./img/image-5.png)

---
### 단계8: nginx 접속 성공 
- Public IP로 접속 시도 

![alt text](./img/image4.png)
