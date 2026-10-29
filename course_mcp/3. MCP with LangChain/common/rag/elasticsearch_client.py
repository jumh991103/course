from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk
from langchain_core.documents import Document
import os

from common.rag.constants import RAGConstants

def get_elasticsearch_client(es_url: str=None, es_user: str=None, es_password: str=None) -> Elasticsearch:
  es_url = es_url or os.environ.get("ELASTICSEARCH_URL")
  es_user = es_user or os.environ.get("ELASTIC_USER")
  es_password = es_password or os.environ.get("ELASTIC_PASSWORD")
  es_client = Elasticsearch(
    es_url,
    basic_auth=(es_user, es_password),
    verify_certs=False,
    ssl_show_warn=False,
    request_timeout=30,
    max_retries=3,
    retry_on_timeout=True,
  )
  if not es_client.ping():
    raise SystemExit("Elasticsearch ping 실패. docker-compose 기동과 인증 정보를 확인하세요.")
  
  return es_client

def create_index(
  es_client: Elasticsearch, index_name: str = RAGConstants.RAG_INDEX_NAME.value, 
  delete_existing: bool = True, emb_vector_dims: int = RAGConstants.OPENAI_EMBEDDING_DIMS.value) -> None:
  
  if delete_existing:
    if es_client.indices.exists(index=index_name):
      es_client.indices.delete(index=index_name)
  elif es_client.indices.exists(index=index_name):
    return index_name

  index_mapping = {
    "mappings": {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "standard"
        },
        "embedding": {
          "type": "dense_vector",
          "dims": emb_vector_dims,  # 임베딩 차원 (모델에 따라 조정)
          "index": True,
          "similarity": "cosine"  # 코사인 유사도
        },
        "metadata": {
          "type": "object",
          "enabled": True
        }
      }
    }
  }

  es_client.indices.create(index=index_name, body=index_mapping)

  return index_name

def insert_documents(
  es_client: Elasticsearch, index_name: str, 
  documents: list[Document], emb_vectors: list[float]) -> None:
  
  def actions():
    for i, (doc, vec) in enumerate(zip(documents, emb_vectors)):
      yield {
        "_index": index_name,
        "_id": f"{index_name}-{i}",
        "_source": {
          "text": doc.page_content,
          "embedding": vec,
          "metadata": doc.metadata,
        },
      }
  success, failed = bulk(es_client, actions(), refresh=True, raise_on_error=False)   
  if failed:
    raise SystemExit(f"Elasticsearch 인덱싱 실패: {failed}")

  # 인덱스 새로고침 (검색 가능하도록)
  es_client.indices.refresh(index=index_name)
  return success


