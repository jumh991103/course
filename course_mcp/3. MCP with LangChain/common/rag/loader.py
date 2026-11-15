from langchain_community.document_loaders import DirectoryLoader
from langchain_community.document_loaders import TextLoader
from langchain_core.documents import Document
from pathlib import Path


def load_documents(data_dir: Path) -> list[Document]:
  loader = DirectoryLoader(
    data_dir, glob="*.txt", loader_cls=TextLoader, loader_kwargs={"encoding": "utf-8"})
  return loader.load()

