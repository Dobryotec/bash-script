variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins (will be generated if empty)"
  type        = string
  default     = "SuperSecret123!"
  sensitive   = true
}