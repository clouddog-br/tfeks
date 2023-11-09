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

resource "helm_release" "node_exporter" {
  depends_on = [ helm_release.prometheus ]
  name       = "prometheus-node-exporter"
  chart      = "prometheus-node-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.node_exporter_helm_chart_version
  namespace  = var.namespace

  values = [
    "${file("${path.module}/prometheus-node-exporter-config.yaml")}"
  ]

}
