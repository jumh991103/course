######################################
# 환경변수 등록 
######################################
from dotenv import load_dotenv

load_dotenv()

######################################
# 웹서비스 
######################################
import streamlit as st 
from common.langgraph.run import response_of_llm
from common.screen.history import create_history
from common.screen.display import print_message

st.title("챗봇 서비스")

######################################
# 챗봇 히스토리
######################################
create_history()

######################################
# 챗봇 - 사용자의 문의
######################################
question = st.chat_input("무엇이든지 물어봐주세요.")
if question is not None:
    user_msg = {
        "role":"user",
        "content":question
    }
    # 화면에 추가 
    print_message(user_msg["role"], user_msg["content"])
    # 이력에 추가 
    st.session_state.messages.append(user_msg)

    ######################################
    # 챗봇 - AI 답변
    ######################################
    ai_msg = {
        "role":"assistant",
        "content":""
    }
    # 화면에 추가 
    response = print_message(ai_msg["role"], response_of_llm(question))
    ai_msg["content"] = response
    
    # 이력에 추가
    st.session_state.messages.append(ai_msg)
        
    
