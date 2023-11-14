data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" { }

locals {
  name   = var.cluster_name
  region = data.aws_region.current.name

  azs = slice(data.aws_availability_zones.available.names, 0, var.qtt_az)

}

module "vpc" {
  source = "./modules/vpc"

  tfname = local.name
  cidr = var.cidr
  create_subnet_public = var.create_subnet_public
  create_subnet_private = var.create_subnet_private
  create_nat_gateway = var.create_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  create_subnet_data = var.create_subnet_data

  azs = local.azs
}

module "eks" {
  source = "./modules/eks"

  tfname = local.name
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  kubernetes_version = var.kubernetes_version
  auth_users = var.auth_users
  auth_roles = var.auth_roles

  azs = local.azs
}

module "eks_karpenter_manifests" {
  depends_on = [ module.eks ]
  source = "./modules/eks-karpenter-manifests"

  cluster_name = module.eks.cluster_name
  azs = local.azs
}

module "eks_rbac_default_roles" {
  depends_on = [ module.eks ]
  source = "./modules/eks-rbac-default-roles"
}

module "eks_loadbalancer" {
  depends_on = [ module.eks, module.eks_karpenter_manifests ]
  source = "./modules/eks-load-balancer-controller"

  cluster_name = module.eks.cluster_name
  aws_region = local.region
  cluster_identity_oidc_issuer = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  helm_chart_version = "1.4.6"
  aws_lb_controller_version = "2.6.1"
  
}

resource "kubernetes_namespace" "es_secret_store_namespace" {
  depends_on = [ module.eks ]
  for_each = toset(var.es_secret_store_namespace)

  metadata {
    name = each.key
  }
}

module "eks-external-secrets" {
  depends_on = [ module.eks, kubernetes_namespace.es_secret_store_namespace ]
  source = "./modules/eks-external-secrets"

  cluster_name = module.eks.cluster_name
  aws_region = local.region
  helm_chart_version = "0.9.8"
  secret_store_namespace = var.es_secret_store_namespace
  cluster_identity_oidc_issuer = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
}

module "eks-ebs-csi-driver" {
  depends_on = [ module.eks, module.eks_karpenter_manifests ]
  source = "./modules/eks-ebs-csi-driver"

  cluster_name = module.eks.cluster_name
  helm_chart_version = "2.23.1"
  cluster_identity_oidc_provider = module.eks.oidc_provider
}

module "eks-prometheus" {
  depends_on = [ module.eks, module.eks-ebs-csi-driver ]
  source = "./modules/eks-prometheus"

  helm_chart_version = "25.1"
  node_exporter_helm_chart_version = "4.23.2"
}

module "eks-grafana" {
  depends_on = [ module.eks, module.eks-ebs-csi-driver ]
  source = "./modules/eks-grafana"

  helm_chart_version = "7.0.3"
}

module "eks-app-mesh" {
  depends_on = [ module.eks, module.eks_karpenter_manifests ]
  source = "./modules/eks-app-mesh"

  cluster_name = module.eks.cluster_name
  helm_chart_version = "v1.12.3"
  
  app_mesh_sidecard_namespace = var.app_mesh_sidecard_namespace
  karpenter_role_name = module.eks.karpenter_role_name
  cluster_identity_oidc_provider = module.eks.oidc_provider
  tracing_enabled = true
}
