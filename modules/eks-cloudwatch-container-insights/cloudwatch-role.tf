resource "aws_iam_role_policy_attachment" "cw_on_karpenter_role" {
  role       = var.karpenter_role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
