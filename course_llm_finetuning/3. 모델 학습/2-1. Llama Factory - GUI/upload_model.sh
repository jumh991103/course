#!/bin/bash
# =====================================================================
# 학습 완료된 모델을 HuggingFace Hub에 업로드하는 스크립트
#
# [사용법] 학습 완료 후 SSH 터미널에서 실행:
#   bash /app/upload_model.sh
#
# [사전 조건]
#   - Pod 환경변수에 HF_TOKEN이 설정되어 있어야 합니다.
#   - WebUI에서 학습이 완료되어 있어야 합니다.
# =====================================================================

set -e

# 스크립트가 위치한 디렉토리 (Python 파일 경로 참조용)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -----------------------------------------------
# 설정값 (필요시 수정)
# -----------------------------------------------
BASE_MODEL="Qwen/Qwen2.5-3B"
ADAPTER_DIR="/app/LLaMA-Factory/saves/Qwen2.5-3B/lora/train_illnesses_dora"
MERGED_OUTPUT_DIR="/app/merged_model"
HF_REPO="good593/qwen2.5-3b-dora-illnesses"

# -----------------------------------------------
# 사전 체크
# -----------------------------------------------
echo "================================================"
echo "  HuggingFace 모델 업로드 시작"
echo "  베이스 모델 : ${BASE_MODEL}"
echo "  어댑터 경로 : ${ADAPTER_DIR}"
echo "  업로드 대상 : ${HF_REPO}"
echo "================================================"

# HF_TOKEN 확인
if [ -z "$HF_TOKEN" ]; then
    echo "[ERROR] HF_TOKEN 환경변수가 설정되지 않았습니다."
    echo "        RunPod Pod 환경변수에 HF_TOKEN을 추가하세요."
    exit 1
fi

# 어댑터 디렉토리 존재 확인
if [ ! -d "$ADAPTER_DIR" ]; then
    echo "[ERROR] 어댑터 디렉토리가 존재하지 않습니다: ${ADAPTER_DIR}"
    echo "        WebUI에서 학습이 완료되었는지 확인하세요."
    echo "        또는 WebUI의 output_dir 설정을 확인하여 경로를 수정하세요."
    exit 1
fi

echo "[INFO] 어댑터 디렉토리 확인 완료: ${ADAPTER_DIR}"
ls -lh "${ADAPTER_DIR}"

# -----------------------------------------------
# Step 1: HuggingFace 로그인
# -----------------------------------------------
echo ""
echo "[STEP 1/3] HuggingFace 로그인 중..."
huggingface-cli login --token "$HF_TOKEN"
echo "[INFO] 로그인 완료"

# -----------------------------------------------
# Step 2: LoRA 어댑터를 베이스 모델에 Merge
# -----------------------------------------------
echo ""
echo "[STEP 2/3] LoRA 어댑터를 베이스 모델에 Merge 중..."
echo "           (시간이 다소 걸릴 수 있습니다)"

mkdir -p "$MERGED_OUTPUT_DIR"

python3 "${SCRIPT_DIR}/merge_model.py" "${BASE_MODEL}" "${ADAPTER_DIR}" "${MERGED_OUTPUT_DIR}"

echo "[INFO] Merge 완료"

# -----------------------------------------------
# Step 3: HuggingFace Hub에 업로드
# -----------------------------------------------
echo ""
echo "[STEP 3/3] HuggingFace Hub에 업로드 중..."
echo "           대상 레포: ${HF_REPO}"

python3 "${SCRIPT_DIR}/upload_to_hf.py" "${MERGED_OUTPUT_DIR}" "${HF_REPO}"

# -----------------------------------------------
# 완료
# -----------------------------------------------
echo ""
echo "================================================"
echo "  ✅ 업로드 완료!"
echo "  모델 URL: https://huggingface.co/${HF_REPO}"
echo "================================================"
