variable "helm_chart_version" {
  type        = string
  default     = "grafana-6.61.1"
  description = "Grafana Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to deploy Grafana Helm chart."
}
