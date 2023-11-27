output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "eks_karpenter_security_group_id" {
  value = aws_security_group.eks_worker_node.id
}
