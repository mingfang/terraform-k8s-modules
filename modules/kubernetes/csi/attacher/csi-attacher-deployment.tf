resource "k8s_apps_v1_deployment" "csi-attacher" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        "app" = var.name
      }
    }
    template {
      metadata {
        labels = {
          "app" = var.name
        }
      }
      spec {

        containers {
          args = [
            "--v=5",
            "--csi-address=$(ADDRESS)",
            "--leader-election",
          ]

          env {
            name = "MY_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name  = "ADDRESS"
            value = "unix://var/lib/csi/sockets/pluginproxy/${var.name}"
          }
          image             = "quay.io/k8scsi/csi-attacher:canary"
          image_pull_policy = "Always"
          name              = var.name

          volume_mounts {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }
        containers {

          env {
            name  = "CSI_ENDPOINT"
            value = "unix://var/lib/csi/sockets/pluginproxy/${var.name}"
          }
          image   = var.image
          args    = var.args
          command = var.command
          env {
            name = "NODE_ID"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          image_pull_policy = "Always"
          name              = "${var.name}-driver"

          volume_mounts {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }
        service_account = var.name

        volumes {
          name = "socket-dir"
        }
      }
    }
  }
}