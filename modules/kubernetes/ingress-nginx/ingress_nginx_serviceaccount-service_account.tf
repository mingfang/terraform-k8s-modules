resource "k8s_core_v1_service_account" "nginx_ingress_serviceaccount" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
}