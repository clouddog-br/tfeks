output "karpenter-irsa-arn" {
    value = module.karpenter.irsa_arn
}

output "helm_karpenter_version" {
    value = helm_release.karpenter.version
}

output "helm_karpenter_namespace" {
    value = helm_release.karpenter.namespace
}

output "karpenter_role_name" {
    value = module.karpenter.role_name
}

output "karpenter_role_arn" {
    value = module.karpenter.irsa_arn
}
