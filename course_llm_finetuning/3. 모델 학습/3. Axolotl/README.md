# Docker Hub에 배포하는 명령어
```shell
docker build -t 도커허브아이디/axolotl-runpod:0.5.0 .
docker push 도커허브아이디/axolotl-runpod:0.5.0

# GPU용
docker run -it --rm --gpus all -p 8888:8888 -v ./workspace:/workspace 도커허브아이디/axolotl-runpod:0.5.0
# CPU용
docker run -it --rm -p 8888:8888 -v ./workspace/workspace:/workspace 도커허브아이디/axolotl-runpod:0.5.0
```

---
# Dockerfile에 포함된 필수 요소
> 멀티 GPU Pod → 학습 → Hugging Face Hub 저장

| 기능        | 라이브러리          | 상태 |
| --------- | -------------- | -- |
| 멀티 GPU 실행 | `accelerate`   | ✅  |
| 분산 학습     | `deepspeed`    | ✅  |
| 모델 학습     | `axolotl`      | ✅  |
| HF Hub 저장 | `transformers` | ✅  |

---

# Axolotl vs Unsloth (Full FT 기준 비교)

| 항목                 | Axolotl      | Unsloth |
| ------------------ | ------------ | ------- |
| Full Fine-Tuning   | ✅ **완전 지원**  | ⚠️ 제한적  |
| DeepSpeed ZeRO-2/3 | ✅            | ❌       |
| FSDP               | ⭕ (실험적)      | ❌       |
| 멀티 GPU 확장          | ✅ (8~64 GPU) | ❌       |
| Optimizer 세부 제어    | ✅            | ❌       |
| Checkpoint 전략      | ✅            | ❌       |
| 대규모 모델(13B+)       | ✅            | ❌       |

---
# 학습 데이터셋 크기 비교

| 구분     | QLoRA       | Full FT       |
| ------ | ----------- | ------------- |
| 강의용 최소 | 100 ~ 300   | 2,000 ~ 5,000 |
| 체감 구간  | 300 ~ 1,000 | 10k ~ 30k     |
| 실무 하한  | 1k ~ 5k     | 100k+         |
| 비용 효율  | ⭐⭐⭐⭐⭐       | ⭐             |

