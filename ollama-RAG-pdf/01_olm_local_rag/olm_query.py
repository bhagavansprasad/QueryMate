from langchain.prompts import ChatPromptTemplate
from langchain.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_community.chat_models import ChatOllama
from langchain_core.runnables import RunnablePassthrough
from langchain.retrievers.multi_query import MultiQueryRetriever
import datetime

from config import LOCAL_MODEL

def olm_query(vct_db):
    llm = ChatOllama(model=LOCAL_MODEL)
    
    QUERY_PROMPT = PromptTemplate(
        input_variables=["question"],
        template="""You are an AI language model assistant. Your task is to generate five
    different versions of the given user question to retrieve relevant documents from
    a vector database. By generating multiple perspectives on the user question, your
    goal is to help the user overcome some of the limitations of the distance-based
    similarity search. Provide these alternative questions separated by newlines.
    Original question: {question}"""
    )

    stime = datetime.datetime.now()
    print(f"start time :{stime}")
    
    retriever = MultiQueryRetriever.from_llm(vct_db.as_retriever(), llm, prompt=QUERY_PROMPT)
    
    template = """Answer the question based ONLY on the following context: {context} Question: {question}"""
    prompt = ChatPromptTemplate.from_template(template=template)
    
    chain = (
        {"context": retriever, "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )
    
    retval = chain.invoke(input(":> "))
    print(f"reply :\n {retval}")
    
    print()
    print(datetime.datetime.now() - stime)
    
