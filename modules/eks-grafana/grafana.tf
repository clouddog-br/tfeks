resource "kubectl_manifest" "grafana_volume" {
  yaml_body = file("${path.module}/grafana-volume.yaml")
}
