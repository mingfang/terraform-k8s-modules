resource "k8s_core_v1_limit_range" "ingress_nginx" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {

    limits {
      min = {
        "cpu"    = "100m"
        "memory" = "90Mi"
      }
      type = "Container"
    }
  }
}