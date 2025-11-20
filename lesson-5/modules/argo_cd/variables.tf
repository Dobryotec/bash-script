variable "cluster_name" {
  type = string
}

variable "django_helm_repo_url" {
  description = "Git repository з Helm-чартом Django (для ArgoCD Application)"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL ECR репозиторію"
  type        = string
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}