FROM menloltd/cortex

# Set working directory
WORKDIR /root/cortexcpp

# Copy cortex config
COPY .cortexrc /root/.cortexrc

# Copy the model files
COPY ./custom_models/ ./custom_models/
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh 

# Start cortex server
RUN cortex start

# Install the engine
RUN cortex engines install llama-cpp

# Import the model
RUN cortex models import --model_id netvrkai-8b --model_path /root/cortexcpp/custom_models/netvrkai-8b.gguf

EXPOSE 39281

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
