# Google ADK — Build Agent (강의 자료)

모델은 기본적으로 **Google Gemini**([Google AI Studio](https://aistudio.google.com/apikey) 무료 API 키)를 씁니다. `.env`에 `GOOGLE_API_KEY` 또는 `GEMINI_API_KEY`를 넣으세요. **OpenAI** 실습은 `OPENAI_API_KEY`와 `1. Models for Agents.ipynb`를 참고하세요.

# [Models for Agents](https://google.github.io/adk-docs/agents/models/)

- Gemini (모델 ID 문자열, 기본)
- OpenAI (`LiteLlm`, 선택)
- Ollama (선택, LiteLLM)

# [Tools](https://google.github.io/adk-docs/integrations/)

- Gmail, Google Search, Google Calendar
- [Custom tools](https://google.github.io/adk-docs/tools-custom/)

# [Context](https://google.github.io/adk-docs/context/)

- Context caching
- Context compression

# [Session & Memory](https://google.github.io/adk-docs/sessions/)

- [InMemorySessionService](https://google.github.io/adk-docs/sessions/session/#the-session-object)
- [DatabaseSessionService](https://google.github.io/adk-docs/sessions/session/#vertexaisessionservice)

# [Callbacks](https://google.github.io/adk-docs/callbacks/)

- Before & After
