# https://www.youtube.com/watch?v=QSW2L8dkaZk

import chromadb
import csv
import sys
import time

from chromadb.utils import embedding_functions

sys.path.append("/home/bhagavan/training/aura-llm/00-utils/")
from debug_helper import whereami

def producer_create_embeddings(collection, csvdata, batchsize=0, queue=None):
    documents = []
    metadata = []
    ids = []
    rfd = 0
    # whereami(f"Embedding csv data csv file name:{csvdata}")

    try:
        rfd = open(csvdata)
    except IOError as err:
        # whereami(f"Error in opening file err :{err}")
        exit(1)

    csvfd = csv.reader(rfd)
    next(csvfd) # skip column header
        
    for i, row in enumerate(csvfd, 2):
        documents.append(row[3])
        metadata.append({'date': row[0], 'time': row[1], 'Author' : row[2]})
        ids.append(str(i))

        results = collection.get(ids=str(i))
        if (len(results['ids']) != 0):
            continue
        
        whereami(f"ids      :{ids}")
        whereami(f"metadata :{metadata}")
        whereami(f"docs     :{documents}")
        print()
        collection.add(documents=documents, metadatas=metadata, ids=ids)
        metadata = []
        documents = []
        ids = []
        # time.sleep(1)
        
    whereami(f"Finished Embedding csv data :{csvdata}")

def server_init_croma_db(vectdb_name, coll_name):
    # whereami()

    client = chromadb.PersistentClient(path=vectdb_name)
    
    sentence_transformer_ef = embedding_functions.SentenceTransformerEmbeddingFunction(model_name="all-mpnet-base-v2")
    collection = client.get_or_create_collection(name=coll_name, embedding_function=sentence_transformer_ef)
    return collection

def dump_collection_details(collection):
    print(collection.get())
    count = collection.count()   
    print()
    # whereami(f"collection count :{count}")
    print()

def delete_collection_by_name(collection_name):
    client = chromadb.Client()
    
    try:
        client.delete_collection(name=collection_name)
        # whereami(f"Successfully Deleted collection :{collection_name}")
    except ValueError as err:
        whereami(f"Collection doesn't exists :{err}")
        pass
        
    return

def main():
    vectdb_name = "DsVectorDB-Media"
    collection_name = "datascience-Media"
    csvdata = "./data/data.csv"
       
    # whereami()
    # delete_collection_by_name(collection_name)
    
    collection = server_init_croma_db(vectdb_name, collection_name)
    producer_create_embeddings(collection, csvdata)

if (__name__ == "__main__"):
    main()
