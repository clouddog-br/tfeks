variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "karpenter_role_name" {
  type        = string
  description = "Karpenter Role Name (Worker Nodes)"
}
