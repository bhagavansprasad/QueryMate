from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_text_splitters import RecursiveCharacterTextSplitter

from config import CHUNK_SIZE
from config import CHUNK_OVERLAP
from config import eMODEL

def olm_embedd_data(data):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP)
    chunks = text_splitter.split_documents(data)
    
    embeddings = OllamaEmbeddings(model=eMODEL, show_progress=True)
    vector_db = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        collection_name="local-rag"
    )
    
    return vector_db