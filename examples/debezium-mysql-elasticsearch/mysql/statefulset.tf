resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas              = var.replicas
    service_name          = k8s_core_v1_service.this.metadata[0].name
    pod_management_policy = "OrderedReady"

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        node_selector = var.node_selector

        containers {
          name  = "mysql"
          image = var.image

          env {
            name  = "MYSQL_USER"
            value = var.mysql_user
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.mysql_password
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_database
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }
          env {
            name  = "TZ"
            value = "UTC"
          }
        }
      }
    }
  }
}
