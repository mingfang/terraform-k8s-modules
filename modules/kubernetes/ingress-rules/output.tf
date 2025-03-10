output "rules" {
  value = k8s_extensions_v1beta1_ingress.this.spec.0.rules
}