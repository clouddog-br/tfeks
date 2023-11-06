output "eks_creation_role" {
  description = "AWS Role to Create the EKS only. It is necessary to follow the best practices and recovery access in case of lost access on RBAC"
  value       = [
    aws_iam_role.eks_creation_role.arn,
    aws_iam_role.eks_creation_role.id,
    aws_iam_role.eks_creation_role.name,
  ]
}

output "assume_role" {
  description = "Assume role to put on main.tf file to assume role and create the eks as this role"
  value = {
    role_arn    = aws_iam_role.eks_creation_role.arn
    external_id = "eks_creation_role"
  }
}

output "auth_users" {
  description = "Auth user to put on terraform.tfvars file to give access on eks to original role"
  value = strcontains(data.aws_caller_identity.current.arn, "user") ? {
    userarn  = data.aws_caller_identity.current.arn
    username = "admin"
    groups = [
      "system:masters",
    ]
  }: null
}

locals {
  is_identity_role = strcontains(data.aws_caller_identity.current.arn, "role")
  curl_rolearn_replaced = local.is_identity_role ? replace(
      replace(data.aws_caller_identity.current.arn,"assumed-", "")
    , "sts", "iam") : null
  cur_rolearn_splitted = local.is_identity_role ? split("/", local.curl_rolearn_replaced) : null
  cur_rolearn = local.is_identity_role ? join("/", slice(local.cur_rolearn_splitted, 0, length(local.cur_rolearn_splitted)-1)) : null
}
output "auth_roles" {
  description = "Auth role to put on terraform.tfvars file to give access on eks to original role"
  value = local.is_identity_role ? [{
    rolearn  = local.cur_rolearn
    username = "admin"
    groups = [
      "system:masters",
    ]
  }]: null
}
