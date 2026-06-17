output "rules" {
  value = k8s_networking_k8s_io_v1_ingress.this.spec.0.rules
}