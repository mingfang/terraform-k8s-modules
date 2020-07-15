resource "k8s_apps_v1_deployment" "ebs_csi_controller" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name      = "ebs-csi-controller"
    namespace = var.namespace
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        "app"                    = "ebs-csi-controller"
        "app.kubernetes.io/name" = "aws-ebs-csi-driver"
      }
    }
    template {
      metadata {
        labels = {
          "app"                    = "ebs-csi-controller"
          "app.kubernetes.io/name" = "aws-ebs-csi-driver"
        }
      }
      spec {

        containers {
          args = [
            "--endpoint=$(CSI_ENDPOINT)",
            "--logtostderr",
            "--v=5",
          ]

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///var/lib/csi/sockets/pluginproxy/csi.sock"
          }
          env {
            name = "AWS_ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                key      = "key_id"
                name     = "aws-secret"
                optional = true
              }
            }
          }
          env {
            name = "AWS_SECRET_ACCESS_KEY"
            value_from {
              secret_key_ref {
                key      = "access_key"
                name     = "aws-secret"
                optional = true
              }
            }
          }
          image             = "amazon/aws-ebs-csi-driver:v0.5.0"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            failure_threshold = 5
            http_get {
              path = "/healthz"
              port = "healthz"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 3
          }
          name = "ebs-plugin"

          ports {
            container_port = 9808
            name           = "healthz"
            protocol       = "TCP"
          }

          volume_mounts {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=5",
            "--feature-gates=Topology=true",
            "--enable-leader-election",
            "--leader-election-type=leases",
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }
          image = "quay.io/k8scsi/csi-provisioner:v1.3.0"
          name  = "csi-provisioner"

          volume_mounts {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=5",
            "--leader-election=true",
            "--leader-election-type=leases",
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }
          image = "quay.io/k8scsi/csi-attacher:v1.2.0"
          name  = "csi-attacher"

          volume_mounts {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }
        containers {
          args = [
            "--csi-address=/csi/csi.sock",
          ]
          image = "quay.io/k8scsi/livenessprobe:v1.1.0"
          name  = "liveness-probe"

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        node_selector = {
          "kubernetes.io/arch" = "amd64"
          "kubernetes.io/os"   = "linux"
        }
        priority_class_name  = "system-cluster-critical"
        service_account_name = "ebs-csi-controller-sa"

        tolerations {
          operator = "Exists"
        }

        volumes {
          empty_dir {
          }
          name = "socket-dir"
        }
      }
    }
  }
}