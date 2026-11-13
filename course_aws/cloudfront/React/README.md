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
# 노트북마켓

React + Vite + Tailwind CSS로 만든 노트북 가격비교 예제 웹사이트.

---
## 프로젝트 구조

- `data/` — Playwright + BeautifulSoup으로 크롤링한 노트북 30종 데이터 (`laptops.csv`, `images/`)
- `design/` — 화면설계 와이어프레임 (`homepage.svg`)
- `scripts/build-data.mjs` — `data/laptops.csv`를 `src/data/laptops.json`으로 변환하는 스크립트
- `src/` — React 앱 소스
  - `components/` — Header, Tabs, FilterBar, ProductGrid, ProductCard, Pagination
  - `data/laptops.json` — 크롤링 데이터를 변환한 상품 데이터

---
# Local PC

---
## 실행 방법

```bash
npm install
npm run dev       
```
![alt text](./img/image.png)

---
> 개발 서버 실행 (http://localhost:5173)

![alt text](./img/image-1.png)

---
데이터를 다시 만들고 싶다면(예: `data/laptops.csv`를 갱신한 경우):

```bash
node scripts/build-data.mjs
```
![alt text](./img/image-2.png)

---
# AWS 배포

---
### Local PC > 프로덕션 빌드
```bash
npm run build 
```
![alt text](./img/image-3.png)

---
### AWS S3 > Bucket 생성 

![alt text](./img/image-4.png)

---
![alt text](./img/image-5.png)

---
![alt text](./img/image-6.png)

---
![alt text](./img/image-7.png)

---
![alt text](./img/image-8.png)

---
> 생성된 Bucket 확인 

![alt text](./img/image-9.png)

---
### AWS IAM > Access keys 설정 확인 

![alt text](./img/image-10.png)

---
![alt text](./img/image-11.png)

---
![alt text](./img/image-12.png)

---
### Local PC > s3에 배포 
```shell
aws s3 sync dist/ s3://cloudfront-tutorial-good593 --profile default
```
![alt text](./img/image-13.png)

---
> 결과 확인 

![alt text](./img/image-14.png)

---
# AWS CloudFront

---
### Create distribution 

![alt text](./img/image-15.png)

---
> Choose a plan

![alt text](./img/image-16.png)

---
![alt text](./img/image-17.png)

---
> Get started

![alt text](./img/image-18.png)

---
> Specify origin

![alt text](./img/image-19.png)

---
![alt text](./img/image-20.png)

---
> Enable security

![alt text](./img/image-21.png)

---
> Review and create

![alt text](./img/image-22.png)

---
### Default root object

![alt text](./img/image-23.png)

---
![alt text](./img/image-24.png)

---
### Error pages

![alt text](./img/image-25.png)

---
![alt text](./img/image-26.png)

---
> 403: Forbidden

![alt text](./img/image-27.png)

---
> 404: Not Found

![alt text](./img/image-28.png)

---
> 결과 확인 

![alt text](./img/image-29.png)

---
### 접속 테스트 

![alt text](./img/image-30.png)

