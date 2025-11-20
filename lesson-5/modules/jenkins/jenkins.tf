resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.3.7"  # актуальна стабільна на листопад 2025
  namespace        = var.jenkins_namespace
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [
    templatefile("${path.module}/values.yaml", {
      admin_password = var.jenkins_admin_password
    })
  ]

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.serviceAnnotations.service.beta.kubernetes.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.installPlugins"
    value = "{kubernetes:4206.v9e0d4f5941fc,workflow-aggregator:597.va_9371ec00f1f,git:5.7.0,aws-credentials:227.v7d2b_4e77f3cb,kaniko:1.23.0,pipeline-aws:1.44}"
  }

  depends_on = [
    kubernetes_namespace.jenkins_ns
  ]
}

resource "kubernetes_namespace" "jenkins_ns" {
  metadata {
    name = var.jenkins_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}