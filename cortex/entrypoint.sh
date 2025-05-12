#!/bin/sh

# Start the cortex server
cortex start

# Install the engine
cortex engines install llama-cpp

# Wait for the engine to be installed
while ! cortex engines list | grep -q "llama-cpp"; do
  echo "Waiting for engine to be installed..."
  sleep 5
done

# Load the engine
curl --request POST --url http://0.0.0.0:39281/v1/engines/llama-cpp/load

cortex models import --model_id netvrkai-8b --model_path /root/cortexcpp/custom_models/netvrkai-8b.gguf

# Start the model
curl --request POST \
  --url http://0.0.0.0:39281/v1/models/start \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "netvrkai-8b"
}'

# Keep the container running by tailing the log files
tail -f /root/cortexcpp/logs/cortex.log &
tail -f /root/cortexcpp/logs/cortex-cli.log &
wait