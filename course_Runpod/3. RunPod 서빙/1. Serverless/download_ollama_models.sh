#!/bin/sh
set -e

# 단일 모델을 빌드 단계에서 다운로드합니다.
# (환경변수로 바꾸고 싶으면 OLLAMA_MODEL=... 로 오버라이드 가능)
MODEL="${OLLAMA_MODEL:-gemma3:4b}"

echo "[build] Starting ollama serve..."
ollama serve >/dev/null 2>&1 &
PID=$!

echo "[build] Waiting for ollama HTTP to be ready..."
i=0
while ! ollama list >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 120 ]; then
    echo "[build] ERROR: ollama did not become ready in time." >&2
    exit 1
  fi
  sleep 1
done

echo "[build] Pulling model: $MODEL"
ollama pull "$MODEL"

echo "[build] Stopping ollama serve..."
kill "$PID" >/dev/null 2>&1 || true

echo "[build] Model download completed."

