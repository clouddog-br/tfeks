variable "helm_chart_version" {
  type        = string
  default     = "7.0.3"
  description = "Grafana Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to deploy Grafana Helm chart."
}
