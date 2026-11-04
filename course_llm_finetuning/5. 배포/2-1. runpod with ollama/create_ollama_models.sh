#!/bin/bash

# ==========================================
# Ollama 모델 생성 스크립트
# ==========================================

# 설정 변수
REPO_ID="good593/gemma3-finetune-diseases-gguf"
FILE_NAME="unsloth-gemma3-1b-finetune-nutrition_q4km.gguf"
OLLAMA_MODEL_NAME="unsloth-gemma3-1b-finetune-nutrition_q4km:1b"

echo "================================================="
echo "1. HuggingFace에서 GGUF 모델 다운로드 시작"
echo "================================================="

# huggingface-cli가 설치되어 있는지 확인 (없으면 wget 등의 방법 고려 가능)
if ! command -v huggingface-cli &> /dev/null
then
    echo "huggingface-cli를 찾을 수 없습니다. pip install -U \"huggingface_hub[cli]\" 를 통해 설치해주세요."
    echo "대안으로 wget을 사용하여 다운로드 시도 중..."
    wget "https://huggingface.co/${REPO_ID}/resolve/main/${FILE_NAME}" -O "${FILE_NAME}"
else
    # huggingface-cli를 사용하여 특정 파일만 현재 디렉토리에 다운로드
    huggingface-cli download "$REPO_ID" "$FILE_NAME" --local-dir . --local-dir-use-symlinks False
fi

# 파일이 정상적으로 다운로드 되었는지 확인
if [ ! -f "$FILE_NAME" ]; then
    echo "오류: 다운로드 실패 - $FILE_NAME 파일을 찾을 수 없습니다."
    exit 1
fi
echo -e "다운로드 완료!\n"

echo "================================================="
echo "2. Ollama 모델 생성 시작 ($OLLAMA_MODEL_NAME)"
echo "================================================="

# ollama 명령어가 사용 가능한지 확인
if ! command -v ollama &> /dev/null
then
    echo "오류: ollama 명령어를 찾을 수 없습니다. Ollama가 설치되어 있는지 확인해주세요."
    exit 1
fi

echo "임시로 ollama 서버를 백그라운드에서 시작합니다..."
ollama serve > ollama.log 2>&1 &
OLLAMA_PID=$!

# 서버 대기 (충분한 시간을 대기)
sleep 5
echo "Ollama 서버가 시작되었습니다. 모델 생성을 진행합니다."

# Modelfile을 이용하여 커스텀 모델 생성
ollama create "$OLLAMA_MODEL_NAME" -f Modelfile
CREATE_RESULT=$?

# 생성 결과 확인
if [ $CREATE_RESULT -eq 0 ]; then
    echo -e "\nOllama 모델 생성 성공!"
    echo "현재 사용 가능한 모델 목록:"
    ollama list
else
    echo -e "\n오류: Ollama 모델 생성 실패."
    # 실패 로깅 확인
    cat ollama.log
fi

echo "임시 ollama 서버를 종료합니다..."
kill $OLLAMA_PID
wait $OLLAMA_PID 2>/dev/null

if [ $CREATE_RESULT -ne 0 ]; then
    exit 1
fi
