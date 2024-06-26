variable "tfname" {
  description = "Tf Name. local.name value"
  type        = string
}

variable "azs" {
  description = "The list of AZ to use"
  type        = list
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private Subnets"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "(Optional) Cluster Endpoint with public access"
  type        = bool
  default     = false
}

variable "auth_users" {
  description = "(Optional) Auth Map Users to be created on EKS"
  type = list
  default = []
}

variable "auth_roles" {
  description = "(Optional) Auth Map Roles to be created on EKS"
  type = list
  default = []
}

variable "karpenter_helm_chart_version" {
  type        = string
  default     = "v0.31.1"
  description = "Karpenter Helm chart version."
}

# variable "kms_key_owners" {
#   type        = list
#   description = "KSM Key Owners"
# }
