"""
RunPod Serverless + vLLM + Hugging Face Hub 모델 예제.

- 모델은 Hugging Face repo ID(MODEL_NAME)에서 받습니다.
- 게이트 모델이면 RunPod 시크릿/환경 변수에 HF_TOKEN 을 넣습니다.
"""
import transformers
import vllm
print(f"DEBUG: Transformers Version -> {transformers.__version__}")
print(f"DEBUG: vLLM Version -> {vllm.__version__}")

import os
from typing import Optional

import runpod
from vllm import LLM, SamplingParams

MODEL_NAME = os.environ["MODEL_NAME"]
_llm: Optional[LLM] = None


def _get_llm() -> LLM:
    global _llm
    if _llm is None:
        _llm = LLM(
            model=MODEL_NAME,
            trust_remote_code=True,
            dtype="bfloat16",           # Gemma3 권장 dtype
            max_model_len=2048,         # OOM 방지: 컨텍스트 길이 제한
            gpu_memory_utilization=0.90, # GPU 메모리 90% 사용
        )
    return _llm


def handler(job: dict) -> dict:
    job_input = job.get("input") or {}
    prompt = job_input.get("prompt")
    if not prompt:
        return {"error": "input.prompt 이 필요합니다."}

    system = (job_input.get("system") or "").strip()
    if system:
        text_in = f"{system}\n\nUser: {prompt}\nAssistant:"
    else:
        text_in = prompt

    temperature = float(job_input.get("temperature", 0.7))
    max_tokens = int(job_input.get("max_tokens", 256))

    llm = _get_llm()
    params = SamplingParams(temperature=temperature, max_tokens=max_tokens)
    outputs = llm.generate([text_in], params)
    answer = outputs[0].outputs[0].text.strip()

    return {"text": answer}


if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})
