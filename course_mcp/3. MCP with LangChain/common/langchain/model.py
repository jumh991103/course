from langchain_openai import ChatOpenAI

def get_model(name:str="gpt-5-nano"):
    return ChatOpenAI(model=name)

