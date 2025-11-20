
output "argocd_url" {
  description = "Зовнішній URL ArgoCD"
  value       = "https://${helm_release.argocd.metadata[0].name}-${helm_release.argocd.namespace}.${var.cluster_name}.eks.amazonaws.com"
}

output "argocd_admin_password" {
  description = "Початковий пароль admin для ArgoCD"
  value       = nonsensitive(base64decode(kubernetes_secret_v1.argocd_initial_admin_secret.data["password"]))
  sensitive   = false   
}

data "kubernetes_secret_v1" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.argocd_namespace
  }
  depends_on = [helm_release.argocd]
}

output "argocd_login_command" {
  description = "Команда для логіну в ArgoCD CLI"
  value       = "argocd login ${helm_release.argocd.status.load_balancer.ingress[0].hostname} --username admin --password $(terraform output -raw argocd_admin_password) --insecure"
}