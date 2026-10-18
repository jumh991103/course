######################################
# 환경변수 등록 
######################################
from dotenv import load_dotenv

load_dotenv()


from langchain_openai import ChatOpenAI
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
import streamlit as st 
import time

@st.cache_resource
def get_model(model:str="gpt-5-nano"):
    return ChatOpenAI(
        model="gpt-5-nano",
        reasoning_effort="high",        # 논리성 강화
    )

def get_response_from_model(question:str):
    # 채팅한 이력 추가 
    prompts = [] 
    for msg in st.session_state.messages:
      prompts.append(tuple(msg.values()))
    
    # 사용자의 메세지 입력 프론프트
    prompts += [("user", "{user_input}")] 
    chat_prompt = ChatPromptTemplate.from_messages(prompts)

    chain = chat_prompt | get_model() | StrOutputParser()
    
    for token in chain.stream({"user_input": question}):
        yield token 
        time.sleep(0.05)
