resource "k8s_apps_v1beta2_daemon_set" "csi-nodeplugin" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
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
            "--csi-address=/plugin/csi.sock",
            "--kubelet-registration-path=/var/lib/kubelet/plugins/${var.name}/csi.sock",
          ]

          env {
            name = "KUBE_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          image = "quay.io/k8scsi/csi-node-driver-registrar:v1.1.0"
          lifecycle {
            pre_stop {
              exec {
                command = [
                  "/bin/sh",
                  "-c",
                  "rm -rf /registration/${var.name} /registration/${var.name}-reg.sock",
                ]
              }
            }
          }
          name = "node-driver-registrar"

          volume_mounts {
            mount_path = "/plugin"
            name       = "plugin-dir"
          }
          volume_mounts {
            mount_path = "/registration"
            name       = "registration-dir"
          }
        }
        containers {
          args = [
            "--v=5",
            "--nodeid=$(NODE_ID)",
            "--endpoint=$(CSI_ENDPOINT)",
          ]

          env {
            name = "NODE_ID"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name  = "CSI_ENDPOINT"
            value = "unix://plugin/csi.sock"
          }
          image   = var.image
          command = var.command

          image_pull_policy = "Always"
          name              = var.name
          security_context {
            allow_privilege_escalation = true
            capabilities {
              add = [
                "SYS_ADMIN",
              ]
            }
            privileged = true
          }

          volume_mounts {
            mount_path = "/plugin"
            name       = "plugin-dir"
          }
          volume_mounts {
            mount_path        = "/var/lib/kubelet/pods"
            mount_propagation = "Bidirectional"
            name              = "pods-mount-dir"
          }
          volume_mounts {
            name       = "alluxio-domain"
            mount_path = "/opt/domain"
          }
        }

        enable_service_links = false
        service_account      = var.name

        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins/${var.name}"
            type = "DirectoryOrCreate"
          }
          name = "plugin-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/pods"
            type = "Directory"
          }
          name = "pods-mount-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins_registry"
            type = "Directory"
          }
          name = "registration-dir"
        }
        volumes {
          name = "alluxio-domain"
          host_path {
            path = "/tmp/alluxio-worker.sock"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}