import streamlit as st 

def create_history():
    if "messages" not in st.session_state:
        st.session_state.messages = [] # 초기화!!! 
    else:
        # 기존에 챗봇 이력 데이터 프린트 
        for message in st.session_state.messages:
            with st.chat_message(message["role"]):
                st.markdown(message["content"]) 
