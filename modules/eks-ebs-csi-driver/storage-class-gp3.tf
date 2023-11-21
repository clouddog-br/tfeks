resource "kubectl_manifest" "storage_class_gp3" {
  depends_on = [ helm_release.aws_ebs_csi_driver ]
  
  yaml_body = <<-YAML
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: gp3
      annotations:
        storageclass.kubernetes.io/is-default-class: "true"
    allowVolumeExpansion: true
    provisioner: ebs.csi.aws.com
    volumeBindingMode: WaitForFirstConsumer
    parameters:
      encrypted: 'true'
      type: gp3
    reclaimPolicy: Retain
  YAML
}
