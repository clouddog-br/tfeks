aws_region = "us-east-1"

# VPC
cidr = "10.0.0.0/16"
qtt_az = 3
create_subnet_public = true
create_subnet_private = true
create_nat_gateway = true
one_nat_gateway_per_az = false
create_subnet_data = true

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
    rolearn = "arn:aws:iam::122753118347:role/AWSReservedSSO_AWSAdministratorAccess_21f7405f253561fa"
    username = "admin"
  }
]

all_outputs = false
es_secret_store_namespace = ["dev", "yelb"]
app_mesh_sidecard_namespace = ["dev", "yelb"]
cluster_name = "teste-apolinario"

