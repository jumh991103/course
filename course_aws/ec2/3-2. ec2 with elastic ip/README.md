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
# EC2 Instance의 Public IP
- Instance를 재기동할때 마다 Public IP가 변경된다.

---
### 단계1: Public IP 확인 
![alt text](./img/image-3.png)

---
### 단계2: Instance Stop
![alt text](./img/image-4.png)

---
![alt text](./img/image-5.png)

---
### 단계3: Instance Stopped > Public IP 없음  
![alt text](./img/image-6.png)

---
### 단계4: Instace Start
![alt text](./img/image-7.png)

---
### 단계5: Public IP 확인 
- 기존 Public IP와 값이 다름 

![alt text](./img/image-8.png)

---
# [Elastic IP](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)
- Elastic IP 주소는 동적 클라우드 컴퓨팅을 위해 고안된 정적 IPv4 주소입니다. 
- [Elastic IP 요금](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#eip-pricing)

---
### 단계1: Allocate Elastic IP address
![alt text](./img/image.png)

---
- Allocate
![bg right w:600](./img/image-1.png)

---
- 생성 확인 

![alt text](./img/image-2.png)

---
### 단계2: Associate elastic ip with ec2 instance
![alt text](./img/image-9.png)

---
### 단계3: Associate
- ec2의 public ip에 elastic ip 연결

![bg right w:600](./img/image-10.png)

---
### 단계4: ec2 public ip
- 생성한 elastic ip가 ec2의 public ip와 같음 

![alt text](./img/image-11.png)

---
### 단계5: ec2 stop
- ec2 stopped가 되었지만 public ip 존재함 

![alt text](./img/image-12.png)

---
# Elastic IP 삭제 

---
### 단계1: Disassociate Elastic IP
![alt text](./img/image-13.png)

---
![alt text](./img/image-15.png)

---
![alt text](./img/image-16.png)

---
### 단계2: 결과 확인 
![alt text](./img/image-17.png)

---
### 단계3: Elastic IP 삭제 
![alt text](./img/image-14.png)

---
![alt text](./img/image-18.png)

---
- 결과 확인 

![alt text](./img/image-19.png)

