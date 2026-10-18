from langchain_openai import ChatOpenAI

def get_model(model:str="gpt-5-nano", tools=None):
    model = ChatOpenAI(
        model=model,
        reasoning_effort="high",        # 논리성 강화
    )

    if isinstance(tools, list) and len(tools):
        return model.bind_tools(tools)
    
    return model