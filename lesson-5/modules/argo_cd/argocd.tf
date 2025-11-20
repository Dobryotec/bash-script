
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.5.2"
  namespace        = var.argocd_namespace
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [file("${path.module}/values.yaml")]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}

resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  chart      = "${path.module}/charts/argocd-apps"
  namespace  = var.argocd_namespace

  depends_on = [helm_release.argocd]

  set {
    name  = "djangoHelmRepoURL"
    value = var.django_helm_repo_url
  }

  set {
    name  = "ecrRepositoryURL"
    value = var.ecr_repository_url
  }
}