# import ollama
import streamlit as st
import consumer_querymate as cqm

def model_response_generator():
    # stream = ollama.chat(
    #     model = st.session_state["model"],
    #     messages = st.session_state["messages"],
    #     stream=True
    # )
    # for chunk in stream:
    #     yield chunk["message"]["content"]
        yield "Hello world"
        yield "Hello Bhagavan"
    
def streamlit_example():
    st.title("Chat-Bot: WhatsApp's Datascience Group")
    
    # initialize history
    if "messages" not in st.session_state:
        st.session_state["messages"] = []
    
    # init models
    if "model" not in st.session_state:
        st.session_state["model"] = "LLM Model: all-mpnet-base-v2"
        
    # models = [m['name'] for m in ollama.list()['models']]
    # models = ["all-mpnet-base-v2"]
    # st.session_state["model"] = st.selectbox("Choose your model", models)
    # model = st.session_state["model"]

    # display chat messages from history
    for message in st.session_state["messages"]:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    prompt = st.chat_input("What is up?")
    if not prompt:
        return 0 
        
    # add latest message to history in format {role, content}
    data = {"role": "user", "content": prompt}
    st.session_state["messages"].append(data)
    with st.chat_message("user"): 
        st.markdown(prompt)

    # communicate with llm
    # with st.chat_message("assistant"):
        # reply = st.write_stream(model_response_generator())
        # reply = model_response_generator()
        # st.session_state["messages"].append(reply)

    reply = cqm.g_client_query_data(prompt)
    hist_data = "'''"
    
    # print(f"reply :{reply}")
    for i, row in enumerate(reply, 1):
        d = f"{i}. {row}"
        st.markdown(d)
        hist_data += d + '\n'

    hist_data += "'''\n"
    # print(f"hist_data :{hist_data}")
    data = {'role': 'assistant', 'content': hist_data}
    st.session_state["messages"].append(data)

def main():
    streamlit_example()
    
if(__name__ == "__main__"):
    main()
    
# Youtube link
#     https://www.youtube.com/watch?v=xa8pTD16SnM&list=PL4041kTesIWby5zznE5UySIsGPrGuEqdB

# Importing Opensource Models
#     https://www.youtube.com/watch?v=fnvZJU5Fj3Q&list=PL4041kTesIWby5zznE5UySIsGPrGuEqdB&index=3

# streamlit
#     streamlit run 01-streamlit-app.py
#     Browse the URL listed
