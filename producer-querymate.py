# https://www.youtube.com/watch?v=QSW2L8dkaZk

import chromadb
import json

from chromadb.utils import embedding_functions

from config import output_file as source_file
from config import vectdb_name
from config import collection_name
from config import eMODEL

def producer_create_embeddings(collection, json_data, batchsize=0, queue=None):
    documents = []
    metadata = []
    ids = []
    data = []

    try:
        with open(json_data, 'r') as rfd:
            data = json.load(rfd)
    except IOError as err:
        exit(1)

    for i, row in enumerate(data, 1):

        # build id
        ids = str(i)

        # build metadata
        mdate, mtime =  row['datetime'].split()
        author = row['sender']
        if not author:
            author = ""
            
        attachment = row['attachment']
        if not attachment:
            attachment = ""
        metadata = {'date': mdate, 'time': mtime, 'Author' : author, 'attachment' : attachment}

        # build document
        documents = row['message']

        results = collection.get(ids=str(i))
        if (len(results['ids']) != 0):
            continue
        
        print(f"ids      :{ids}")
        print(f"metadata :{metadata}")
        print(f"docs     :{documents}")
        print()
        collection.add(documents=documents, metadatas=metadata, ids=ids)
        # time.sleep(1)
        
    print(f"Finished Embedding csv data :{json_data}")

def server_init_croma_db(vectdb_name, coll_name):
    client = chromadb.PersistentClient(path=vectdb_name)
    
    sentence_transformer_ef = embedding_functions.SentenceTransformerEmbeddingFunction(model_name="all-mpnet-base-v2")
    collection = client.get_or_create_collection(name=coll_name, embedding_function=sentence_transformer_ef)
    return collection

def dump_collection_details(collection):
    print(collection.get())
    count = collection.count()   
    print()
    # print(f"collection count :{count}")
    print()

def delete_collection_by_name(collection_name):
    client = chromadb.Client()
    
    try:
        client.delete_collection(name=collection_name)
        # print(f"Successfully Deleted collection :{collection_name}")
    except ValueError as err:
        print(f"Collection doesn't exists :{err}")
        pass
        
    return

def main():
    print(f"Source file :{source_file}")

    collection = server_init_croma_db(vectdb_name, collection_name)
    producer_create_embeddings(collection, source_file)
    print(f"Finished creating embeddings...")

if (__name__ == "__main__"):
    main()
