variable "helm_chart_version" {
  type        = string
  default     = "25.4"
  description = "Prometheus Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to deploy Prometheus Helm chart."
}
