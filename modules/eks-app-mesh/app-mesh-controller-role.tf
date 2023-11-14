module "app_mesh_controller_role" {
  depends_on = [ aws_iam_policy.app_mesh_controller, kubernetes_namespace.app_mesh_namespace ]
  
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                   = true
  role_name                     = "${var.cluster_name}-app-mesh-controller"
  provider_url                  = var.cluster_identity_oidc_provider
  role_policy_arns              = [
    aws_iam_policy.app_mesh_controller.arn
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
}

data "http" "aws-app-mesh-controller-policy" {
  url = "https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/controller-iam-policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "local_file" "aws-app-mesh-controller-policy" {
  depends_on  = [data.http.aws-app-mesh-controller-policy]
  content  = data.http.aws-app-mesh-controller-policy.response_body
  filename = "${path.module}/downloaded-controller-iam-policy.json"
}

resource "aws_iam_policy" "app_mesh_controller" {
  depends_on  = [data.http.aws-app-mesh-controller-policy]
  name        = "${var.cluster_name}-app-mesh-controller"
  path        = "/"
  description = "Policy for App Mesh Controller"

  policy = data.http.aws-app-mesh-controller-policy.response_body
}

resource "kubernetes_service_account" "app_mesh_sa" {
  depends_on = [ module.app_mesh_controller_role ]

  metadata {
    name        = var.service_account_name
    namespace   = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.app_mesh_controller_role.iam_role_arn
    }
  }

  automount_service_account_token = true

}
