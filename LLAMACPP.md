```bash
docker build -t local/llama.cpp:server-cuda --target server -f ./llama.cpp/.devops/cuda.Dockerfile .
docker-compose up
```
