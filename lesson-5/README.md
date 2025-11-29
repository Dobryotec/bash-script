# Final DevOps Project

## Architecture Overview

| Component          | Technology                                   | Purpose                      |
| ------------------ | -------------------------------------------- | ---------------------------- |
| Cloud              | AWS                                          | Infrastructure as Code       |
| IaC                | Terraform                                    | All resources                |
| Network            | VPC + private/public subnets                 | Isolation                    |
| Container Registry | ECR                                          | Docker images                |
| Kubernetes         | EKS                                          | Application runtime          |
| Database           | RDS Aurora PostgreSQL / single               | Persistent storage           |
| CI                 | Jenkins (Helm)                               | Build → ECR → Git commit     |
| CD                 | ArgoCD (Helm)                                | GitOps continuous deployment |
| Application        | Django (custom Helm chart)                   | Example workload             |
| Monitoring         | Prometheus + Grafana (kube-prometheus-stack) | Metrics, alerts, dashboards  |
| Autoscaling        | HPA (CPU + Memory)                           | Horizontal Pod Autoscaler    |

---

## Features

- Universal RDS module (`use_aurora = true/false`)
- Full GitOps via ArgoCD
- Automated CI/CD pipeline (Jenkins → ECR → Git → ArgoCD)
- Production-grade security (private subnets, SG, IAM)
- Observability stack (Prometheus + Grafana)
- Autoscaling based on CPU and memory
- Zero manual operations after `terraform apply`

---

## How to Deploy

```bash
# 1. Clone & checkout final branch
git clone https://github.com/Dobryotec/bash-script.git
cd bash-script
git checkout final-project

# 2. Deploy everything
terraform init
terraform plan
terraform apply   # type "yes" when prompted
```

## All resources are created automatically:

- EKS cluster
- Jenkins, ArgoCD, Prometheus+Grafana via Helm
- RDS (Aurora by default)
- Django app deployed via Helm chart

## Access Applications:

# Connect to EKS

$(terraform output -raw how_to_connect_eks)

# Jenkins

kubectl port-forward svc/jenkins 8080:8080 -n jenkins → http://localhost:8080
(admin / check output for password)

# ArgoCD

kubectl port-forward svc/argocd-server 8081:443 -n argocd →
https://localhost:8081 (admin / check output for password)

# Grafana

kubectl port-forward svc/grafana 3000:80 -n monitoring → http://localhost:3000
(admin / admin123)

# Django Application

kubectl get svc django-app → access via LoadBalancer external IP

## CI/CD Pipeline Flow

git push (to final-project branch)  
↓ Jenkins → builds Docker image from Django/app/  
↓ Push to ECR with git commit tag  
↓ Update image.tag in charts/django-app/values.yaml  
↓ git commit + push back to repository  
↓ ArgoCD detects change → automatic sync  
↓ New pods with updated image + HPA + monitoring

## Cleanup

```bash
terraform destroy # destroys ALL resources including S3 bucket & DynamoDB table
```
