resource "kubernetes_namespace" "app_mesh_namespace" {

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "appmesh_controller" {
  depends_on = [ kubernetes_service_account.app_mesh_sa ]
  name       = "appmesh-controller"
  chart      = "appmesh-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = false


  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }
  set {
    name  = "tracing.enabled"
    value = var.tracing_enabled
  }

}
