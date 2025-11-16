# Lesson 7: EKS + Django + Helm

This project deploys:

- VPC with public and private subnets
- S3 + DynamoDB for Terraform state
- ECR repository
- EKS Kubernetes cluster
- Helm chart for deploying a Django application

---

## Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform ≥ 1.0
- Docker
- `kubectl`
- `helm`
- Local Django Docker image from Lesson 4 (`my-django-app:latest`)

---

## Deploy Infrastructure (Terraform)

```bash
# Initialize
terraform init

# Review plan
terraform plan -var-file=variables.tfvars

# Apply
terraform apply -var-file=variables.tfvars

```

2. Post-Deployment Steps (Run in Terminal)

2.1 Connect to EKS Cluster

```bash
# Update kubeconfig
aws eks update-kubeconfig --name lesson-7-eks --region us-west-2

# Verify connection
kubectl get nodes
```

2.2 Build and Push Docker Image to ECR

```bash
# Build image from Dockerfile
docker build -t my-django-app:latest .

# Get ECR repository URL
ECR_URL=$(terraform output -raw ecr_repository_url)
echo "ECR Repository URL: $ECR_URL"

# Authenticate Docker to ECR
aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS --password-stdin $ECR_URL

# Tag local image
docker tag my-django-app:latest $ECR_URL:latest

# Push to ECR
docker push $ECR_URL:latest
```

2.3 Install Helm Chart

```bash
# Install or upgrade the Django app
helm upgrade --install django-app ./charts/django-app \
  --set image.repository=$ECR_URL \
  --set image.tag=latest
```

2.4 Verify Deployment

```bash
# Check pods
kubectl get pods -l app.kubernetes.io/name=django-app

# Check service
kubectl get svc django-app

# Get external URL (wait 1–2 minutes)
kubectl get svc django-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}'

# Check HPA
kubectl get hpa

# View ConfigMap
kubectl get configmap django-app -o yaml
```

Cleanup (Optional)

```bash
# Uninstall Helm release
helm uninstall django-app

# Destroy infrastructure
terraform destroy -var-file=variables.tfvars
```
