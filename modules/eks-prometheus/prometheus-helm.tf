resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/prometheus-config.yaml")}"
  ]

}
