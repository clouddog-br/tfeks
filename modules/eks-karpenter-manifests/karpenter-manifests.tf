resource "kubectl_manifest" "karpenter_default_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
      labels:
        role: intel
      requirements:
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ["c", "m"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["4"]
        - key: "karpenter.k8s.aws/instance-cpu"
          operator: In
          values: ["4", "8", "16", "32"]
        - key: "karpenter.k8s.aws/instance-hypervisor"
          operator: In
          values: ["nitro"]
        - key: "topology.kubernetes.io/zone"
          operator: In
          values: ${jsonencode(var.azs)}
        - key: "kubernetes.io/arch"
          operator: In
          values: ["amd64"]
        - key: "karpenter.sh/capacity-type" # If not included, the webhook for the AWS cloud provider will default to on-demand
          operator: In
          values: ["spot", "on-demand"]
      kubeletConfiguration:
        containerRuntime: containerd
        imageGCHighThresholdPercent: 85
        imageGCLowThresholdPercent: 80
      consolidation:
        enabled: true
      providerRef:
        name: default
      ttlSecondsUntilExpired: 604800 # 7 Days = 7 * 24 * 60 * 60 Seconds
      weight: 10
  YAML
}

# resource "kubectl_manifest" "karpenter_graviton_provisioner" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.sh/v1alpha5
#     kind: Provisioner
#     metadata:
#       name: graviton
#     spec:
#       labels:
#         role: graviton
#       requirements:
#         - key: "karpenter.k8s.aws/instance-category"
#           operator: In
#           values: ["c", "m"]
#         - key: karpenter.k8s.aws/instance-generation
#           operator: Gt
#           values: ["4"]
#         - key: "karpenter.k8s.aws/instance-cpu"
#           operator: In
#           values: ["8", "16", "32"]
#         - key: "karpenter.k8s.aws/instance-hypervisor"
#           operator: In
#           values: ["nitro"]
#         - key: "topology.kubernetes.io/zone"
#           operator: In
#           values: ${jsonencode(var.azs)}
#         - key: "kubernetes.io/arch"
#           operator: In
#           values: ["arm64"]
#         - key: "karpenter.sh/capacity-type" # If not included, the webhook for the AWS cloud provider will default to on-demand
#           operator: In
#           values: ["spot", "on-demand"]
#       kubeletConfiguration:
#         containerRuntime: containerd
#         imageGCHighThresholdPercent: 85
#         imageGCLowThresholdPercent: 80
#       consolidation:
#         enabled: true
#       providerRef:
#         name: default
#       ttlSecondsUntilExpired: 604800 # 7 Days = 7 * 24 * 60 * 60 Seconds
#       weight: 10
#   YAML
# }

resource "kubectl_manifest" "karpenter_monitoring_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: monitoring
    spec:
      labels:
        role: monitoring
      requirements:
        - key: node.kubernetes.io/instance-type
          operator: In
          values: ["t3.large"]
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ["t"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["2"]
        - key: "karpenter.k8s.aws/instance-hypervisor"
          operator: In
          values: ["nitro"]
        - key: "topology.kubernetes.io/zone"
          operator: In
          values: ${jsonencode(slice(var.azs, 0, 1))}
        - key: "kubernetes.io/arch"
          operator: In
          values: ["amd64"]
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["on-demand"]
      kubeletConfiguration:
        containerRuntime: containerd
        imageGCHighThresholdPercent: 85
        imageGCLowThresholdPercent: 80
      consolidation:
        enabled: false
      providerRef:
        name: default
      ttlSecondsUntilExpired: 604800 # 7 Days = 7 * 24 * 60 * 60 Seconds
      weight: 1
  YAML
}

resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        karpenter.sh/discovery: ${var.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${var.cluster_name}
      tags:
        karpenter.sh/discovery: ${var.cluster_name}
  YAML
}

# # Example deployment using the [pause image](https://www.ianlewis.org/en/almighty-pause-container)
# # and starts with zero replicas
# resource "kubectl_manifest" "karpenter_example_deployment" {
#   yaml_body = <<-YAML
#     apiVersion: apps/v1
#     kind: Deployment
#     metadata:
#       name: inflate
#     spec:
#       replicas: 0
#       selector:
#         matchLabels:
#           app: inflate
#       template:
#         metadata:
#           labels:
#             app: inflate
#         spec:
#           terminationGracePeriodSeconds: 0
#           containers:
#             - name: inflate
#               image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
#               resources:
#                 requests:
#                   cpu: 1
#   YAML

#   depends_on = [
#     helm_release.karpenter
#   ]
# }
