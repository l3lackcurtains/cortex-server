# Deployment Guide for Silk Cortex on GKE with Pulumi, Ansible, and Cortex CLI

## Docker Commands

```bash
# Build the Docker Image
docker build -t silk-cortex .
# Run the Docker Container
docker run --name silk-cortex -p 3939:39281 silk-cortex
# Test the Docker Container
curl -X POST http://localhost:3939/v1/models/start -H "Content-Type: application/json" -d '{"model": "silkai-8b"}'
# Stop the Docker Container
docker stop silk-cortex
# Remove the Docker Container
docker rm silk-cortex
# Remove the Docker Image
docker rmi silk-cortex
```

## Push Docker Image to GCR

```bash
gcloud auth login
gcloud config set project PROJECT_ID
gcloud auth configure-docker
docker login gcr.io
docker tag silk-cortex gcr.io/citric-lead-450721-v2/silk-cortex:1.0.0
docker push gcr.io/citric-lead-450721-v2/silk-cortex:1.0.0
```

## Ansible Commands

```bash
pip install ansible
ansible-galaxy collection install google.cloud community.kubernetes
ansible-playbook deploy_gke.yml
```

## Cortex Commands

```bash
cortex models import --model_id codellama-7b.Q2_K --model_path /root/custom-models/codellama-7b.Q2_K.gguf
cortex models list
cortex models start codellama-7b.Q2_K --gpus [0,1] --ctx_len 286720
cortex models stop codellama-7b.Q2_K
cortex models delete codellama-7b.Q2_K
cortex run codellama-7b.Q2_K
```

## GKE Installation

```bash
# List available accelerators
gcloud compute accelerator-types list

# Create a cluster with 2 nodes and 1 A100 GPU
gcloud container clusters create cortex-cluster --machine-type a2-highgpu-1g --accelerator type=nvidia-tesla-a100 --min-nodes 1 --max-nodes 5 --enable-autoscaling --num-nodes 2 --region us-west1 --node-locations us-west1-b

# Create a cluster with 2 nodes and 1 T4 GPU
gcloud container clusters create cortex-cluster --machine-type g2-standard-4 --accelerator type=nvidia-l4 --min-nodes 1 --max-nodes 5 --enable-autoscaling --num-nodes 2 --region us-west1 --node-locations us-west1-a

# Use the cluster for kubectl
gcloud container clusters get-credentials cortex-cluster --zone us-west1
kubectl config current-context

# Delete the cluster
gcloud container clusters delete cortex-cluster --zone=us-west1

gcloud config get-value project
gcloud config get-value compute/region
```

## Install Nvidia Drivers

```bash
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
```

## Monitoring

```bash
kubectl get nodes
kubectl get deployments --all-namespaces
kubectl logs deployment/cortex -n default
kubectl get deployment cortex -o yaml
kubectl get pods -l app=cortex
kubectl describe pod cortex-6f5ff5866-zxlql
kubectl get pods -n default
kubectl get services -n default
kubectl get pvc,pv
```

## Deployment

```bash
kubectl apply -f cortex-deployment.yaml
kubectl apply -f cortex-service.yaml
kubectl apply -f caddy-ingress.yaml
```

## Delete Resources

```bash
kubectl delete -f cortex-deployment.yaml
kubectl delete -f cortex-service.yaml
kubectl delete -f cortex-ingress.yaml
```

## Setup Caddy

```bash
helm repo add caddy-ingress https://caddyserver.github.io/ingress/
helm repo update
helm install caddy-ingress caddy-ingress/caddy-ingress-controller
# Uninstall
helm uninstall caddy-ingress
helm repo remove caddy-ingress
```

## Dockerfile

```bash
docker build -t cortex-gpu .
docker run --gpus all -p 5151:39281 cortex-gpu cortex start

# For Google Cloud
docker build -t gcr.io/ollama/cortex:latest .
gcloud auth configure-docker
docker push gcr.io/ollama/cortex:latest
```

```yaml
containers:
    - name: my-app-container
        image: gcr.io/ollama/cortex:latest
        ports:
        - containerPort: 80
```
