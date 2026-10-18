######################################
# 웹서비스 
######################################
import streamlit as st 

st.title("챗봇 서비스")

######################################
# 챗봇 히스토리
######################################
if "messages" not in st.session_state:
    st.session_state.messages = [] # 초기화!!! 
else:
    # 기존에 챗봇 이력 데이터 프린트 
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"]) 

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
        "content":"[AI답변] "+question
    }
    # 이력에 추가
    st.session_state.messages.append(ai_msg)
    # 화면에 추가
    with st.chat_message(ai_msg["role"]):
        st.markdown(ai_msg["content"])
