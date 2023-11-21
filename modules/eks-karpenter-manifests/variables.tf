variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "azs" {
  description = "The list of AZ to use"
  type        = list
}
