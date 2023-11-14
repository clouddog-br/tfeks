data "http" "aws-app-mesh-envoy-policy" {
  url = "https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/config/iam/envoy-iam-policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "local_file" "aws-app-mesh-envoy-policy" {
  depends_on  = [data.http.aws-app-mesh-envoy-policy]
  content  = data.http.aws-app-mesh-envoy-policy.response_body
  filename = "${path.module}/downloaded-controller-iam-policy.json"
}

resource "aws_iam_policy" "app_mesh_envoy" {
  depends_on  = [data.http.aws-app-mesh-envoy-policy]
  name        = "${var.cluster_name}-app-mesh-envoy"
  path        = "/"
  description = "Policy for App Mesh Envoy proxy"

  policy = data.http.aws-app-mesh-envoy-policy.response_body
}

resource "aws_iam_role_policy_attachment" "app_mehs_on_karpenter_role" {
  role       = var.karpenter_role_name
  policy_arn = aws_iam_policy.app_mesh_envoy.arn
}

resource "aws_iam_role_policy_attachment" "xray_on_karpenter_role" {
  role       = var.karpenter_role_name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
