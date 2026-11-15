
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.documents import Document

def split_documents(
  documents: list[Document],
  chunk_size: int = 300,
  chunk_overlap: int = 30,
  separators: str = "\n\n",
) -> list[Document]:

  text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=chunk_size, chunk_overlap=chunk_overlap, separators=separators)
  return text_splitter.split_documents(documents)
