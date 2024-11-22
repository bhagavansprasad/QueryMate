from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_community.document_loaders import OnlinePDFLoader

from olm_embendding import olm_embedd_data
from olm_query import olm_query

pdf_list = [
    "./case-study.pdf",
]

def get_data_by_pdf(file):
    try:
        loader = UnstructuredPDFLoader(file_path=file)
        data = loader.load()
    except Exception as err:
        print(f"Error in opening file {file} --> {err}")
        return None

    return data

def main():
    for file in pdf_list:
        data = get_data_by_pdf(file)
        
        if (not data):
            continue
        
        print(data)
        vct_db = olm_embedd_data(data)
        reply = olm_query(vct_db)

if (__name__ == "__main__"):
    main()