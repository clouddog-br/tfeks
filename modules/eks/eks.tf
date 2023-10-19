data "aws_default_tags" "tags" {}

locals {
  name = var.tfname

  aws_auth_roles = concat(
    local.auth_roles_karpenter,
    # local.auth_roles_lb,
    var.auth_roles,
    []
  )

  aws_auth_users = concat(
    var.auth_users,
    []
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.17"

  cluster_name                   = local.name
  cluster_version                = var.kubernetes_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access     

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  manage_aws_auth_configmap = true
  aws_auth_roles = local.aws_auth_roles
  aws_auth_users = local.aws_auth_users


  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  # Get version of add on using:
  # aws eks describe-addon-versions --addon-name kube-proxy
  cluster_addons = {
    kube-proxy = {
      addon_version = "v1.27.1-eksbuild.1"
    }
    vpc-cni    = {
      addon_version = "v1.15.0-eksbuild.2"
    }
    coredns = {
      addon_version = "v1.10.1-eksbuild.4"
      configuration_values = jsonencode({
        computeType = "Fargate"
        # Ensure that we fully utilize the minimum amount of resources that are supplied by
        # Fargate https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
        # Fargate adds 256 MB to each pod's memory reservation for the required Kubernetes
        # components (kubelet, kube-proxy, and containerd). Fargate rounds up to the following
        # compute configuration that most closely matches the sum of vCPU and memory requests in
        # order to ensure pods always have the resources that they need to run.
        resources = {
          limits = {
            cpu = "0.25"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "256M"
          }
          requests = {
            cpu = "0.25"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "256M"
          }
        }
      })
    }
  }


  fargate_profiles = {
    karpenter = {
      selectors = [
        { namespace = "karpenter" }
      ]
    }
    vpc-cni = {
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "aws-node"
          }
        }
      ]
    }
    coredns = {
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        }
      ]
    }
  }

  tags = merge(data.aws_default_tags.tags.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
  })
}
