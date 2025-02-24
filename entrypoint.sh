#!/bin/sh

# Start the cortex server
cortex start

# Load the engine
curl --request POST --url http://127.0.0.1:39281/v1/engines/llama-cpp/load

# Start the model
curl --request POST \
  --url http://127.0.0.1:39281/v1/models/start \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "Deepseek-nexa"
}'

# Keep the container running by tailing the log files
tail -f /root/cortexcpp/logs/cortex.log &
tail -f /root/cortexcpp/logs/cortex-cli.log &
wait