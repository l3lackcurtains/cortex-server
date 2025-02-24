### Kubernetes Deployment files

- `silk-cortex-deployment.yaml` - Deployment file for the Cortex container
- `silk-cortex-service.yaml` - Service file for the Cortex container
- `caddy-config.yaml` - Caddy configuration file
- `caddy-deployment.yaml` - Deployment file for the Caddy container

### Push Image to GCR

```bash
docker build -t silk-cortex .
gcloud auth login
gcloud config set project PROJECT_ID
gcloud auth configure-docker
# Login to GCR
docker login gcr.io
# Tag the image
docker tag silk-cortex gcr.io/citric-lead-450721-v2/silk-cortex:1.0.0
# Push the image to GCR
docker push gcr.io/citric-lead-450721-v2/silk-cortex:1.0.0
```

## Ansible Playbook

```bash
pip install ansible
ansible-galaxy collection install google.cloud community.kubernetes

# Deployment
ansible-playbook deploy_gke.yaml

# Cleanup
ansible-playbook cleanup_gke.yaml
```

### Kubernetes Commands

```bash
# Get pods
kubectl get pods
# Get services
kubectl get services
# Check logs
kubectl logs <pod-name>
```
