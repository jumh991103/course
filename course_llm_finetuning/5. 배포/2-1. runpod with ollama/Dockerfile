FROM ollama/ollama:0.11.6

WORKDIR /

# Install Python (base image does not include it)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip ca-certificates wget && \
    rm -rf /var/lib/apt/lists/*


# Build-time model to download.
ARG OLLAMA_MODEL="unsloth-gemma3-1b-finetune-nutrition_q4km:1b"
ENV OLLAMA_MODEL=${OLLAMA_MODEL}

# Create Ollama model(s) during image build.
COPY Modelfile /Modelfile
COPY create_ollama_models.sh /create_ollama_models.sh
RUN sed -i 's/\r$//' /create_ollama_models.sh && chmod +x /create_ollama_models.sh && bash /create_ollama_models.sh

# Copy your handler file
COPY handler.py /
COPY test_input.json /
# Install dependencies
COPY requirements.txt /requirements.txt
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    -r /requirements.txt

# Start the container
# Base image has ENTRYPOINT ["ollama"], so override it.
ENTRYPOINT ["python3", "-u", "/handler.py"]