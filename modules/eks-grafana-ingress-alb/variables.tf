variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to deploy Grafana Helm chart."
}

variable "alb_name" {
  type        = string
  default     = "alb-grafana"
  description = "Grafana ALB Name"
}

variable "alb_group_order" {
  type        = number
  default     = 1
  description = "Grafana ALB Group Order"
}

variable "alb_security_groups" {
  type        = string
  # default     = "sg-xxxxxxxxxx"
  description = "Grafana ALB Security Groups"
}

variable "alb_certificate_arn" {
  type        = string
  # default     = "arn:aws:acm:us-east-1:xxxxxxxx:certificate/xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
  description = "Grafana ALB Certificate Arn"
}
