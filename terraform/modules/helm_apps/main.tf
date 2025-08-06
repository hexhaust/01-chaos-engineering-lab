resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  values = [file("${path.module}/argocd-values.yaml")]
  depends_on = [var.depends_on]
}

resource "helm_release" "litmus" {
  name       = "litmus"
  repository = "https://litmuschaos.github.io/litmus-helm/"
  chart      = "litmus"
  namespace  = "litmus"
  create_namespace = true
  depends_on = [var.depends_on]
}

resource "helm_release" "monitoring" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  depends_on = [var.depends_on]
}

resource "helm_release" "loki" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "monitoring"
  create_namespace = false

  set {
    name  = "grafana.enabled"
    value = "false"
  }
  depends_on = [var.depends_on]
}