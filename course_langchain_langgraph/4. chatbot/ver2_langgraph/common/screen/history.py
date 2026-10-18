import streamlit as st 
import uuid
from .display import print_history_message

def create_history():
    if "messages" not in st.session_state:
        st.session_state.messages = [] # 초기화!!! 
        st.session_state.memory_id = str(uuid.uuid4())
    else:
        print_history_message()
