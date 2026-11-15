"""
Step 2: LoRA 어댑터를 베이스 모델에 Merge하는 스크립트

사용법:
    python3 merge_model.py <BASE_MODEL> <ADAPTER_DIR> <MERGED_OUTPUT_DIR>
"""
import sys
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel


def main():
    if len(sys.argv) != 4:
        print("Usage: python3 merge_model.py <BASE_MODEL> <ADAPTER_DIR> <MERGED_OUTPUT_DIR>")
        sys.exit(1)

    base_model_name = sys.argv[1]
    adapter_dir = sys.argv[2]
    merged_output_dir = sys.argv[3]

    print("[Python] 베이스 모델 로딩 중...")
    base_model = AutoModelForCausalLM.from_pretrained(
        base_model_name,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True,
    )
    tokenizer = AutoTokenizer.from_pretrained(
        base_model_name,
        trust_remote_code=True,
    )

    print("[Python] LoRA 어댑터 적용 중...")
    model = PeftModel.from_pretrained(base_model, adapter_dir)

    print("[Python] 어댑터 Merge 및 저장 중...")
    model = model.merge_and_unload()
    model.save_pretrained(merged_output_dir, safe_serialization=True)
    tokenizer.save_pretrained(merged_output_dir)

    print(f"[Python] Merge 완료 → {merged_output_dir}")


if __name__ == "__main__":
    main()
