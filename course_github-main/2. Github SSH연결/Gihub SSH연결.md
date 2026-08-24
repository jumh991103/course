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
# Git & Github with SSH 연결

---
### (옵션) 만약 github이 있다면, 삭제 
![bg right w:600](./img/image.png)

---
### (옵션) 만약 .ssh 폴더가 없다면, 실행 
```shell
PS> cd ~ 
PS> mkdir .ssh
```
![bg right w:600](./img/image-2.png)

---
### 단계1: Windows에서 SSH Key 생성
> VS Code 터미널이나 PowerShell에서 실행하세요.
```shell
ssh-keygen -t ed25519 -C "GitHub에등록된이메일"  -f "$HOME\.ssh\id_ed25519_[적절하게 이름수정]"
```
![w:800](./img/image-3.png)

---
### 단계2: .pub 파일을 GitHub에 등록 

![alt text](./img/image-4.png)

---
> ssh hub 복사

![alt text](./img/image-5.png)

---
> Github > Settings

![alt text](./img/image-6.png)

---
> SSH > ssh hub 키 등록 

![alt text](./img/image-7.png)

---
> ssh hub 저장

![alt text](./img/image-8.png)

---
> 확인 

![alt text](./img/image-9.png)

---
### 단계3: vscode 연동
> 익스탠션 설치 

![alt text](./img/image-10.png)

---
> Ctrl + Shift + P를 누르고
```shell
SSH Profiles: Open Manager
```
![alt text](./img/image-11.png)

---
![alt text](./img/image-12.png)

---
> ssh private 적용

![bg right w:600](./img/image-13.png)

---
![alt text](./img/image-14.png)

---
> config에서 Host 별칭 확인

![alt text](./img/image-15.png)

---
> config에서 확인한 Host 별칭 적용 
```shell
ssh -T git@[Host 별칭]
```
![alt text](./img/image-16.png)

---
### 단계4: clone 방법
- Profile 별칭 확인 
- Host 별칭 확인

![alt text](./img/image-17.png)

---
- 저장소명 확인 

![alt text](./img/image-18.png)

---
> Ctrl + Shift + P → Git: Clone → Clone from GitHub
```shell
# git@[Host 별칭]:[Profile 별칭]/[저장소명].git

git@github.com-mrcho593:mrcho593/project-toturial.git
```
![alt text](./img/image-19.png)

---
![alt text](./img/image-20.png)


