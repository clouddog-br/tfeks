resource "aws_security_group" "eks_worker_node" {
  depends_on = [ aws_security_group.alb ]

  name        = "${var.cluster_name}-eks-worker-node-sg"
  description = "EKS Worder Node sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Allow self access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "${var.cluster_name}-eks-worker-node-sg",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}
