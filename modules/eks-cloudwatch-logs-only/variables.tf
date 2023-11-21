variable "helm_chart_version" {
  type        = string
  description = "App Mesh Controller Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "fluentbit-system"
  description = "Kubernetes namespace to deploy App Mesh Controller Helm chart."
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller service account name"
}

variable "cwlogRetentionDays" {
  type        = string
  description = "CloudWatch Log Retention Days"
}

variable "karpenter_role_name" {
  type        = string
  description = "Karpenter Role Name (Worker Nodes)"
}
