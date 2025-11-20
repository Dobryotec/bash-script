output "jenkins_url" {
  description = "External URL of Jenkins"
  value       = "http://${helm_release.jenkins.status.load_balancer.ingress[0].hostname}"
}

output "admin_password" {
  description = "Jenkins admin password"
  value       = var.jenkins_admin_password
  sensitive   = true
}

output "namespace" {
  value = var.jenkins_namespace
}