# Docker Setup for Ollama Server

Here's a complete setup for hosting an Ollama server using Docker:

## Dockerfile

```dockerfile
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
```

## docker-compose.yml

```yaml
version: '3'

services:
  ollama:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ollama-server
    ports:
      - "11434:11434"
    volumes:
      - ollama_models:/models
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

volumes:
  ollama_models:
    driver: local
```

## Usage Instructions

1. Save these files in the same directory
2. Build and start the container:
   ```bash
   docker-compose up -d
   ```
3. Pull a model:
   ```bash
   curl -X POST http://localhost:11434/api/pull -d '{"model": "llama2"}'
   ```
4. To use the API:
   ```bash
   curl -X POST http://localhost:11434/api/generate -d '{"model": "llama2", "prompt": "Hello, world!"}'
   ```

### Notes

- The configuration includes NVIDIA GPU support. If you don't have a GPU, you can remove the `deploy` section.
- Models are stored in a persistent volume `ollama_models`.
- The server listens on all interfaces (0.0.0.0) and is exposed on port 11434.
- You can customize environment variables for more configuration options.