resource "helm_release" "grafana" {
  depends_on = [ kubectl_manifest.grafana_volume ]

  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/grafana-config.yaml")}"
  ]

}
