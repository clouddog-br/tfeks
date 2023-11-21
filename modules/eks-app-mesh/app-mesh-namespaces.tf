resource "kubernetes_labels" "namespaces_for_run_app_mesh_sidecard" {
  for_each = toset(var.app_mesh_sidecard_namespace)

  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = each.key
  }
  labels = {
    "mesh" = "app-mesh",
    "appmesh.k8s.aws/sidecarInjectorWebhook" = "enabled"
  }
}

resource "kubectl_manifest" "app_mesh_manifest_match_labels" {
  depends_on = [
    helm_release.appmesh_controller,
    kubernetes_labels.namespaces_for_run_app_mesh_sidecard
  ]
  
  yaml_body = <<-YAML
    apiVersion: appmesh.k8s.aws/v1beta2
    kind: Mesh
    metadata:
      name: app-mesh
    spec:
      namespaceSelector:
        matchLabels:
          mesh: app-mesh
  YAML
}