# variables.tf — Final Project Version
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "s3_bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "final-project-tfstate-2025"   # ← унікальна назва
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "final-project-vpc"
}

variable "ecr_name" {
  description = "ECR repository name"
  type        = string
  default     = "final-project-ecr"
}

variable "ecr_scan_on_push" {
  type    = bool
  default = true
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "final-project-eks"
}

variable "django_helm_repo_url" {
  description = "Git repository with Helm chart (watched by ArgoCD)"
  type        = string
  default     = "https://github.com/Dobryotec/bash-script"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project   = "final-project"
    Owner     = "student"
    ManagedBy = "terraform"
    Purpose   = "devops-final-exam"
  }
}

variable "enable_jenkins" {
  description = "Deploy Jenkins"
  type        = bool
  default     = true
}

variable "enable_argocd" {
  description = "Deploy ArgoCD"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Deploy Prometheus + Grafana"
  type        = bool
  default     = true
}