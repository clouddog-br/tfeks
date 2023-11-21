variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_identity_oidc_provider" {
  type        = string
  description = "The OIDC Identity provider for the cluster."
}

variable "helm_chart_version" {
  type        = string
  description = "App Mesh Controller Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "appmesh-system"
  description = "Kubernetes namespace to deploy App Mesh Controller Helm chart."
}

variable "app_mesh_sidecard_namespace" {
  type        = list(string)
  description = "Namespaces to Run App Mesh sidecards"
}

variable "karpenter_role_name" {
  type        = string
  description = "Karpenter Role Name (Worker Nodes)"
}

variable "service_account_name" {
  type        = string
  default     = "appmesh-controller-sa"
  description = "App Mesh Controller Service Account Name"
}

variable "tracing_enabled" {
  type        = string
  default     = true
  description = "Tracing eabled to App Mesh? (could be changed between x-ray, jaeger or datadog. Default x-ray)"
}
