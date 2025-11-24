# Lesson 9 — Universal RDS / Aurora Module + Full CI/CD (Lesson 8)

This repository combines:

- **Full CI/CD pipeline from Lesson 8** (Jenkins + ArgoCD + Helm + EKS)
- **NEW reusable production-grade RDS module** that can create:
  - Regular RDS instance (PostgreSQL/MySQL)
  - Aurora PostgreSQL cluster  
    …with just one flag: `use_aurora = true/false`

---

### Features

- `use_aurora = true` → Aurora PostgreSQL cluster + writer instance
- `use_aurora = false` → single RDS instance
- Automatically creates:
  - DB Subnet Group
  - Security Group (ingress only from VPC)
  - Custom Parameter Group (`log_statement=all`, `work_mem=8192`)
- Supports PostgreSQL & MySQL
- Fully reusable, typed variables with defaults

### Usage Examples

```hcl
# Aurora PostgreSQL (recommended for production)
module "db_aurora" {
  source = "./modules/rds"

  use_aurora         = true
  cluster_identifier = "prod-aurora"
  db_name            = "myapp"
  username           = "admin"
  password           = "SuperSecret123!"
  engine             = "postgres"
  instance_class     = "db.r6g.large"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
}

# Regular RDS PostgreSQL (for testing / legacy)
module "db_single" {
  source = "./modules/rds"

  use_aurora         = false
  cluster_identifier = "test-single"
  db_name            = "testdb"
  username           = "admin"
  password           = "SuperSecret123!"
  allocated_storage  = 50
  instance_class     = "db.t3.medium"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
}

```

## Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform ≥ 1.0
- Docker
- `kubectl`
- `helm`
- `jenkins`(for pipeline setup)
- GitHub Personal Access Token for Jenkins (repo rights)
- Local Django Docker image from Lesson 4 (`my-django-app:latest`)

---

## CI/CD Scheme

git push (changes in Django code) → Jenkins (runs Jenkinsfile) → build Docker
image → push to ECR with GIT_COMMIT tag → update image.tag in
charts/django-app/values.yaml → git commit/push back to the repository → ArgoCD
sees the change → automatic sync → new deployment in EKS (Deployment, Service,
HPA, ConfigMap).

---

## Deploy Infrastructure (Terraform)

```bash
# Initialize
terraform init

# Review plan
terraform plan

# Apply
terraform apply

```

After apply, you will get outputs:

- ecr_repository_url
- eks_cluster_name
- jenkins_url + jenkins_admin_password
- argocd_url + argocd_admin_password

2. Post-Deployment Steps (Run in Terminal)

2.1 Connect to EKS Cluster

```bash
# Terraform already shows the exact command in outputs:
terraform output how_to_connect_eks

# Or run it directly (always correct name/region)
aws eks update-kubeconfig --name lesson-9-eks --region us-west-2

# Verify connection
kubectl get nodes
```

2.2 Set up Jenkins (once)

- Open jenkins_url in browser
- Login: admin / password from output
- Manage Jenkins → Credentials → Add:

  1. ID: ecr-url (Secret text, value: ecr_repository_url)

  2. ID: github-token (Secret text, value: your GitHub PAT)

- New Item → Pipeline → name "Django-CI"

  1. Pipeline from SCM → Git → repository:
     https://github.com/Dobryotec/bash-script

  2. Branch: lesson-db-module

  3. Script Path: Jenkinsfile

  4. Save

  2.3 Set up ArgoCD (once)

  - Open argocd_url in browser
  - Login: admin / password from output
  - Check Application "django-prod" — it should synchronize automatically

    2.4 Build and Push Docker Image (test pipeline run)

```bash
# Build local (optional)
docker build -t my-django-app:latest ./app

# Run Jenkins pipeline in browser (Build Now)
# It will build, push to ECR, update tag, push to Git
# ArgoCD will automatically deploy the new image (check in ArgoCD UI)
```

2.5 Verify Deployment

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

# Check ArgoCD status
kubectl get applications -n argocd
```

Cleanup (Optional)

```bash
# Uninstall Helm release
helm uninstall django-app

# Destroy infrastructure
terraform destroy
```
