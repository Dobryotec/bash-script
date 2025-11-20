# variables.tf
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "s3_bucket_name" {
  type    = string
  default = "neo-lesson8-cicd-bucket"
}

variable "dynamodb_table_name" {
  type    = string
  default = "terraform-locks"
}

variable "vpc_cidr_block" { type = string; default = "10.0.0.0/16" }
variable "public_subnets" { type = list(string); default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] }
variable "private_subnets" { type = list(string); default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] }
variable "availability_zones" { type = list(string); default = ["us-west-2a", "us-west-2b", "us-west-2c"] }
variable "vpc_name" { type = string; default = "lesson-8-vpc" }

variable "ecr_name" { type = string; default = "lesson-8-ecr" }
variable "ecr_scan_on_push" { type = bool; default = true }

variable "cluster_name" { type = string; default = "lesson-8-eks" }

variable "django_helm_repo_url" {
  description = "Git repository URL з Helm-чартом (для ArgoCD)"
  type        = string
  default     = "https://github.com/Dobryotec/bash-script"  
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "lesson-8"
    Owner     = "student"
    ManagedBy = "terraform"
  }
}

variable "enable_jenkins" {
  description = "Enable or disable Jenkins deployment"
  type        = bool
  default     = true
}

variable "enable_argocd" {
  description = "Enable or disable ArgoCD deployment"
  type        = bool
  default     = true
}