FROM ubuntu:22.04

# Set up environment
ENV OLLAMA_HOST="0.0.0.0"
ENV OLLAMA_MODELS_PATH="/models"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Create models directory
RUN mkdir -p /models

# Expose port
EXPOSE 11434

# Set entrypoint
ENTRYPOINT ["/bin/ollama"]
CMD ["serve"]
