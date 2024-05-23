aws_region = "us-east-1"
cluster_name = "clouddog-prod-eks"

# VPC
vpc_id = "vpc-023c987cb3c83e473"
private_subnets = ["subnet-0bd5bdd63d0ff7c8c", "subnet-076a03916bd4158b3"]

# EKS
cluster_endpoint_public_access = true #only for tests, it must be private with VPN
kubernetes_version = "1.29"

# # Ex of auth_users
# auth_users = [
#   {
#     userarn  = "arn:aws:iam::66666666666:user/user1"
#     username = "user1"
#     groups   = ["system:masters"]
#   },
#   {
#     userarn  = "arn:aws:iam::66666666666:user/user2"
#     username = "user2"
#     groups   = ["system:masters"]
#   },
# ]

# # Ex of auth_users
# auth_roles = [
#   {
#     rolearn  = data.aws_caller_identity.original.arn
#     username = "system:node:{{EC2PrivateDNSName}}"
#     groups = [
#       "system:bootstrappers",
#       "system:nodes",
#     ]
#   }
# ]
auth_roles = [
  {
    groups = [
      "system:masters",
    ]
    rolearn = "arn:aws:iam::xxxx:role/AWSReservedSSO_AWSAdministratorAccess_xxxxxxx"
    username = "admin"
  }
]

all_outputs = false
es_secret_store_namespace = ["prd"]
app_mesh_sidecard_namespace = ["prd"]
# cluster_name = "EMPRESA-prd"
# certificate_arn = "arn:aws:acm:us-east-1:xxxxxxxx:certificate/xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
