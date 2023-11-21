aws_region = "us-east-1"

# VPC
cidr = "10.2.0.0/16"
qtt_az = 3
create_subnet_public = true
create_subnet_private = true
create_nat_gateway = true
one_nat_gateway_per_az = true
create_subnet_data = true
default_aws_tags = {
  Environment = "prd"
}

# EKS
cluster_endpoint_public_access = true #only for tests, it must be private with VPN
kubernetes_version = "1.28"

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

