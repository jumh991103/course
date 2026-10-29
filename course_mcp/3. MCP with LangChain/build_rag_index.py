import sys
import argparse
from pathlib import Path

from dotenv import load_dotenv

_ROOT = Path(__file__).resolve().parent
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

load_dotenv(_ROOT / ".env")

from common.rag.elasticsearch_client import get_elasticsearch_client, create_index, insert_documents
from common.rag.loader import load_documents
from common.rag.splitter import split_documents
from common.rag.embedding import get_embedding_model, embed_documents

def main() -> None:
    parser = argparse.ArgumentParser(description="RAG 인덱스 빌드")
    parser.add_argument("--recreate", action="store_true", help="기존 인덱스를 삭제하고 새로 생성")
    args = parser.parse_args()

    docs = load_documents(Path(_ROOT / "data")) # 데이터 로드
    split_docs = split_documents(docs) # 문서 분할
    emb_vectors = embed_documents(split_docs, get_embedding_model()) # 임베딩
    es_client = get_elasticsearch_client() # Elasticsearch 클라이언트 생성
    index_name = create_index(es_client, delete_existing=args.recreate) # 인덱스 생성
    success = insert_documents(es_client, index_name, split_docs, emb_vectors) # 문서 삽입
    print(f"인덱싱 완료: {success}개 성공")

if __name__ == "__main__":
    main()
