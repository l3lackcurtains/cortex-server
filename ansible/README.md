### Steps to deploy through ansible

```bash
# Setup ansible
pip install ansible
ansible-galaxy collection install google.cloud community.kubernetes

# Login to GCP
gcloud auth login
gcloud config set project rack-lead

# Deploy cluster with llama cpp and caddy
ansible-playbook gke_deploy.yaml
# Cleanup llama cpp and caddy
ansible-playbook gke_cleanup.yaml
```

### Scaling the node pool

```bash
gcloud container clusters update rack-cluster --enable-autoscaling --min-nodes=1 --max-nodes=3 --node-pool=gpu-pool
```
