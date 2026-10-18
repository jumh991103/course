######################################
# 웹서비스 
######################################
import streamlit as st 
from common.model import get_response_from_model
from common.history import create_history

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
    # 이력에 추가 
    st.session_state.messages.append(user_msg)
    # 화면에 추가 
    with st.chat_message(user_msg["role"]):
        st.markdown(user_msg["content"]) 

    ######################################
    # 챗봇 - AI 답변
    ######################################
    ai_msg = {
        "role":"assistant",
        "content":""
    }
    # 화면에 추가
    with st.chat_message(ai_msg["role"]):
        message = st.empty()
        # 모델 답변 
        for res_token in get_response_from_model(question):
            ai_msg["content"] += res_token
            message.markdown(ai_msg["content"])
    
        # 이력에 추가
        st.session_state.messages.append(ai_msg)
    
