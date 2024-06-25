# https://www.youtube.com/watch?v=QSW2L8dkaZk

import chromadb
import sys
from chromadb.utils import embedding_functions
import time
import json

sys.path.append("/home/bhagavan/training/aura-llm/00-utils/")
from debug_helper import whereami

collection = None
vectdb_name = "DsVectorDB-Media"
collection_name = "datascience-Media"

def client_query_data(collection, query, result_count=2):
    # whereami(f"Query :{query}")    
    print(f"\nQuery :{query}")    
    details = ['distances', 'metadatas', 'documents']
    results = collection.query(query_texts = query, n_results=result_count, include=details)
    
    return(results)


def server_init_croma_db(vectdb_name, coll_name):
    # whereami()

    client = chromadb.PersistentClient(path=vectdb_name)
    
    sentence_transformer_ef = embedding_functions.SentenceTransformerEmbeddingFunction(model_name="all-mpnet-base-v2")
    collection = client.get_or_create_collection(name=coll_name, embedding_function=sentence_transformer_ef)
    return collection

def dump_collection_details(collection):
    count = collection.count()   
    whereami(f"collection count :{count}")

    time.sleep(5)

    print(collection.get())
    print()

def dump_results(reply):
    # jdata = json.dumps(reply)
    # print(jdata)

    ids = reply["ids"][0]
    metadata = reply["metadatas"][0]
    documents = reply["documents"][0]

    # whereami(f"ids       :{ids}")
    # whereami(f"metadata  :{metadata}")
    # whereami(f"documents :{documents}")

    for i, id in enumerate(ids):
        datetime = f"{metadata[i]['date']} {metadata[i]['time']}"
        author = metadata[i]['Author']
        reply = documents[i]
        
        print(f"\t{id}: {author} ({datetime}) :~$ {documents[i]}")
        yield f"{author} ({datetime}) :~$ {documents[i]}"

queries = [
    {'query' : ['quick bytes solution'], 'qcount' : 10},
    {'query' : ['Create a user-defined function Quick Chicken Bites'], 'qcount' : 10},
    # {'query' : ['assignment 2'], 'qcount' : 2},
    # {'query' : ['Messages from Bhagavan'], 'qcount' : 5},
    # {'query' : ['Baljeet contact number please'], 'qcount' : 2},
    # {'query' : ['Who is Rachana Pathak'], 'qcount' : 2},
    # {'query' : ['Who create the group'], 'qcount' : 2},
    # {'query' : ['Extract all mobile numbers please'], 'qcount' : 5},
    # {'query' : ['nano command is used for?'], 'qcount' : 2},
    # {'query' : ['Can you extract URLs please'], 'qcount' : 5},
    # {'query' : ['Can you extract URLs like starting with http please'], 'qcount' : 5},
    # {'query' : ['zoom links please'], 'qcount' : 5},
    # {'query' : ['Messages from Bhagavan'], 'qcount' : 5},
]

def g_client_query_data(query):
    global collection
    
    if (collection == None):
        collection = server_init_croma_db(vectdb_name, collection_name)
        
    results = client_query_data(collection, query, result_count=10)
    retval = dump_results(results)
    reply = list(retval)
    print(reply)
    print()
    return reply

def main():
    collection = server_init_croma_db(vectdb_name, collection_name)
    
    # dump_collection_details(collection)
    
    for q in queries:
        reply = client_query_data(collection, q['query'], result_count=q['qcount'])
        retval = dump_results(reply)
        print(list(retval))
        print()
        
if (__name__ == "__main__"):
    main()
