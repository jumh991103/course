from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document
from common.rag.constants import RAGConstants

def get_embedding_model(model_name: str = RAGConstants.OPENAI_EMBEDDING_MODEL.value) -> OpenAIEmbeddings:
  return OpenAIEmbeddings(model=model_name)

def embed_documents(documents: list[Document], embedding_model: OpenAIEmbeddings) -> list[float]:
  return embedding_model.embed_documents([doc.page_content for doc in documents])

