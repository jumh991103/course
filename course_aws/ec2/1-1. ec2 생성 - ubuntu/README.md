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
### 단계1: ec2 접속 
![alt text](./img/image.png)

---
### 단계2: Launch Instance
![alt text](./img/image-1.png)

---
### 단계3: Namge and tags
> 생성될 인스턴스 이름

![alt text](./img/image-2.png)

---
### 단계4: Application and OS Images
> 생성될 인스턴스에 설치될 OS

![w:900](./img/image-3.png)

---
- select Ubuntu Server 

![alt text](./img/image-4.png)

---
- 결과 확인 

![alt text](./img/image-5.png)

---
### 단계5: Instance type
> 생성될 인스턴스의 스펙(CPU & RAM 등) 

![alt text](./img/image-6.png)

---
- `t2.micro`: 무료 인스턴스(컴퓨터)

![alt text](./img/image-7.png)

---
### 단계6: Key pair
> 생성될 인스턴스에 접속할 열쇠

![alt text](./img/image-8.png)

---
- Create key pair

![bg right w:600](./img/image-9.png)

---
- 생성된 key pair로 세팅됨 

![alt text](./img/image-11.png)

---
- 다운로드된 파일 확인 

![alt text](./img/image-10.png)

---
### 단계7: Network settings
![w:900](./img/image-12.png)

---
![w:900](./img/image-13.png)

---
- `Inbound Security Group Rules`: ssh 확인  

![w:900](./img/image-14.png)

---
### 단계8: Configure storage & Launch instance
![alt text](./img/image-15.png)

---
### 단계9: 생성된 인스턴스 및 Running 상태 확인 

![alt text](./img/image-16.png)
