# Docker Hub에 배포하는 명령어
```shell
docker build -t 도커허브아이디/gguf-runpod:0.6.0 .
docker push 도커허브아이디/gguf-runpod:0.6.0

docker run -it --rm -p 8888:8888 -v ./workspace:/workspace 도커허브아이디/gguf-runpod:0.6.0
```

---
# Dockerfile에 포함된 필수 요소
> HF Hub 모델 → GGUF 변환

| 기능           | 라이브러리 / 도구                         | 상태 |
| ------------ | ---------------------------------- | -- |
| HF 모델 다운로드   | `huggingface-cli` / `transformers` | ✅  |
| HF → GGUF 변환 | `llama.cpp`                        | ✅  |
| GGUF 메타 처리   | `gguf`                             | ✅  |
| Quantization | `llama-quantize`                   | ✅  |



