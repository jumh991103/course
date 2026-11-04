"""
Step 3: 병합된 모델을 HuggingFace Hub에 업로드하는 스크립트

사용법:
    python3 upload_to_hf.py <MERGED_OUTPUT_DIR> <HF_REPO>
"""
import sys
import os
from huggingface_hub import HfApi


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 upload_to_hf.py <MERGED_OUTPUT_DIR> <HF_REPO>")
        sys.exit(1)

    merged_output_dir = sys.argv[1]
    hf_repo = sys.argv[2]

    api = HfApi()

    # 레포 생성 (이미 존재하면 그냥 사용)
    try:
        api.create_repo(
            repo_id=hf_repo,
            repo_type="model",
            private=False,
            exist_ok=True,
        )
        print(f"[Python] 레포 확인/생성 완료: {hf_repo}")
    except Exception as e:
        print(f"[Python] 레포 생성 중 오류 (무시): {e}")

    # 모델 파일 업로드
    print("[Python] 파일 업로드 중...")
    api.upload_folder(
        folder_path=merged_output_dir,
        repo_id=hf_repo,
        repo_type="model",
        commit_message="Upload fine-tuned Qwen2.5-3B (DoRA) model trained on illnesses-dataset",
    )
    print(f"[Python] 업로드 완료!")
    print(f"[Python] 모델 URL: https://huggingface.co/{hf_repo}")


if __name__ == "__main__":
    main()
