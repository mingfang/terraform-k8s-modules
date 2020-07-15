resource "k8s_apps_v1_daemon_set" "ebs_csi_node" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name      = "ebs-csi-node"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app"                    = "ebs-csi-node"
        "app.kubernetes.io/name" = "aws-ebs-csi-driver"
      }
    }
    template {
      metadata {
        labels = {
          "app"                    = "ebs-csi-node"
          "app.kubernetes.io/name" = "aws-ebs-csi-driver"
        }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {

              node_selector_terms {

                match_expressions {
                  key      = "eks.amazonaws.com/compute-type"
                  operator = "NotIn"
                  values = [
                    "fargate",
                  ]
                }
              }
            }
          }
        }

        containers {
          args = [
            "node",
            "--endpoint=$(CSI_ENDPOINT)",
            "--logtostderr",
            "--v=5",
          ]

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:/csi/csi.sock"
          }
          image = "amazon/aws-ebs-csi-driver:v0.5.0"
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
          security_context {
            privileged = true
          }

          volume_mounts {
            mount_path        = "/var/lib/kubelet"
            mount_propagation = "Bidirectional"
            name              = "kubelet-dir"
          }
          volume_mounts {
            mount_path = "/csi"
            name       = "plugin-dir"
          }
          volume_mounts {
            mount_path = "/dev"
            name       = "device-dir"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
            "--v=5",
          ]

          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          env {
            name  = "DRIVER_REG_SOCK_PATH"
            value = "/var/lib/kubelet/plugins/ebs.csi.aws.com/csi.sock"
          }
          image = "quay.io/k8scsi/csi-node-driver-registrar:v1.1.0"
          lifecycle {
            pre_stop {
              exec {
                command = [
                  "/bin/sh",
                  "-c",
                  "rm -rf /registration/ebs.csi.aws.com-reg.sock /csi/csi.sock",
                ]
              }
            }
          }
          name = "node-driver-registrar"

          volume_mounts {
            mount_path = "/csi"
            name       = "plugin-dir"
          }
          volume_mounts {
            mount_path = "/registration"
            name       = "registration-dir"
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
            name       = "plugin-dir"
          }
        }
        host_network = true
        node_selector = {
          "kubernetes.io/arch" = "amd64"
          "kubernetes.io/os"   = "linux"
        }
        priority_class_name = "system-node-critical"

        tolerations {
          operator = "Exists"
        }

        volumes {
          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
          name = "kubelet-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins/ebs.csi.aws.com/"
            type = "DirectoryOrCreate"
          }
          name = "plugin-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins_registry/"
            type = "Directory"
          }
          name = "registration-dir"
        }
        volumes {
          host_path {
            path = "/dev"
            type = "Directory"
          }
          name = "device-dir"
        }
      }
    }
  }
}