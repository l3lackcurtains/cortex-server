### Kubernetes Deployment files

- `rack-deployment.yaml` - Deployment file for the Cortex container
- `rack-service.yaml` - Service file for the Cortex container
- `caddy-config.yaml` - Caddy configuration file
- `caddy-deployment.yaml` - Deployment file for the Caddy container

### Push Image to GCR

```bash
docker build -t rack-cortex .
gcloud auth login
gcloud config set project rack-lead
gcloud auth configure-docker
# Login to GCR
docker login gcr.io
# Tag the image
docker tag rack-cortex gcr.io/rack-lead/rack-cortex:1.0.0
# Push the image to GCR
docker push gcr.io/rack-lead/rack-cortex:1.0.0
```

## Ansible Playbook

```bash
pip install ansible
ansible-galaxy collection install google.cloud community.kubernetes

# Deployment
ansible-playbook ./ansible/deploy_gke.yaml

# Cleanup
ansible-playbook ./ansible/cleanup_gke.yaml
```

### Kubernetes Commands

```bash
# Get pods
kubectl get pods
# Get services
kubectl get services
# Check logs
kubectl logs <pod-name>
# Testing nvidia gpu driver
kubectl run -it --rm --image=nvidia/cuda:11.0-base --restart=Never cuda-test -- nvidia-smi

# Check node pools
gcloud container node-pools list --cluster rack-cluster --zone us-central1-a

# Check node pool status
gcloud container node-pools describe gpu-pool --cluster rack-cluster --zone us-central1-a
```