import streamlit as st
from langchain_core.prompts import ChatPromptTemplate
import time
from .graph import create_graph


def response_of_llm(question:str):
    
    config = {"configurable": {"thread_id": st.session_state.memory_id}}
    
    # 사용자의 메세지 입력 프론프트
    prompts = [("user", "{user_input}")] 
    chat_prompt = ChatPromptTemplate.from_messages(prompts)

    chain = chat_prompt | create_graph()
    response = chain.invoke({"user_input": question}, stream_mode="values", config=config)
    for token in response["messages"][-1].content:
      yield token
      time.sleep(0.05) 

