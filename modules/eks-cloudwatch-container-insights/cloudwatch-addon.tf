resource "aws_eks_addon" "cloudwatch" {
  cluster_name = var.cluster_name
  addon_name   = "amazon-cloudwatch-observability"
  # addon_version = "v1.10.1-eksbuild.1"
}