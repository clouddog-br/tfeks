resource "kubectl_manifest" "grafana_ingress" {
  yaml_body = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      namespace: ${var.namespace}
      name: grafana-ingress
      annotations:
        # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/load-balancer-name: ${var.alb_name}
        alb.ingress.kubernetes.io/group.name: ${var.alb_name}
        alb.ingress.kubernetes.io/group.order: '${var.alb_group_order}'
        alb.ingress.kubernetes.io/security-groups: ${var.alb_security_groups}
        alb.ingress.kubernetes.io/ssl-redirect: '443'
        alb.ingress.kubernetes.io/listen-ports: "[{\"HTTP\":80,\"HTTPS\": 443}]"
        alb.ingress.kubernetes.io/load-balancer-attributes: "idle_timeout.timeout_seconds=300"
        alb.ingress.kubernetes.io/certificate-arn: "${var.alb_certificate_arn}"
        alb.ingress.kubernetes.io/ip-address-type: dualstack
        alb.ingress.kubernetes.io/backend-protocol: HTTP
        alb.ingress.kubernetes.io/healthcheck-path: /healthz
    spec:
      ingressClassName: alb
      rules:
        - # host: nginx.labs.clouddog.com.br # Line add to use host
          http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: grafana
                  port: 
                    number: 80
  YAML
}
