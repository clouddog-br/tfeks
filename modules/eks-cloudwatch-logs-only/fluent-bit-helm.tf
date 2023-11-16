resource "kubernetes_namespace" "fluent_bit" {

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "fluent_bit" {
  depends_on = [ kubernetes_namespace.fluent_bit ]
  name       = "aws-for-fluent-bit"
  chart      = "aws-for-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  version    = var.helm_chart_version
  namespace  = var.namespace
  create_namespace = false

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "cloudWatch.logRetentionDays"
    value = var.cwlogRetentionDays
  }

}
