import os
import subprocess
import time

from typing import Optional

import ollama
import runpod


OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
DEFAULT_MODEL = os.getenv("OLLAMA_MODEL", "unsloth-gemma3-1b-finetune-nutrition_q4km:1b")


def _wait_for_ollama_ready(timeout_s: int = 60) -> None:
    """Ollama HTTP 서버가 준비될 때까지 대기합니다."""
    start = time.time()
    while time.time() - start < timeout_s:
        try:
            ollama.Client(host=OLLAMA_BASE_URL).list()
            return
        except Exception:
            pass
        time.sleep(0.5)
    raise RuntimeError(
        f"Ollama server is not reachable at {OLLAMA_BASE_URL} after {timeout_s}s"
    )


def ensure_ollama_server() -> None:
    """Ollama 서버가 안 떠 있으면 `ollama serve`를 실행합니다."""
    try:
        ollama.Client(host=OLLAMA_BASE_URL).list()
        return
    except Exception:
        pass

    print("Ollama 서버가 꺼져 있어 `ollama serve`를 시작합니다.")
    subprocess.Popen(
        ["ollama", "serve"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    _wait_for_ollama_ready()


def ollama_chat(prompt: str, model: str, system: Optional[str] = None) -> str:
    """Ollama SDK로 1회 호출하고 최종 답변 문자열을 반환합니다."""
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    client = ollama.Client(host=OLLAMA_BASE_URL)
    result = client.chat(model=model, messages=messages)
    return (result.get("message") or {}).get("content", "")


def handler(event):
    """RunPod Serverless handler. (스트리밍 없음)"""
    job_input = event.get("input", {}) if isinstance(event, dict) else {}

    prompt = job_input.get("prompt")
    if not prompt:
        raise ValueError("input.prompt is required")

    model = job_input.get("model", DEFAULT_MODEL)
    system = job_input.get("system")
    return ollama_chat(prompt=prompt, model=model, system=system)


if __name__ == "__main__":
    ensure_ollama_server() # ollama 서버 준비

    runpod.serverless.start({"handler": handler}) # serverless 시작

