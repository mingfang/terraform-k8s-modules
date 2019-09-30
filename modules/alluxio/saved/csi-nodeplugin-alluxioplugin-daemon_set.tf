resource "k8s_apps_v1beta2_daemon_set" "csi-nodeplugin-alluxioplugin" {
  metadata {
    name      = "csi-nodeplugin-alluxioplugin"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app" = "csi-nodeplugin-alluxioplugin"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "csi-nodeplugin-alluxioplugin"
        }
      }
      spec {

        containers {
          args = [
            "--v=5",
            "--csi-address=/plugin/csi.sock",
            "--kubelet-registration-path=/var/lib/kubelet/plugins/csi-alluxioplugin/csi.sock",
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
                  "rm -rf /registration/csi-alluxioplugin /registration/csi-alluxioplugin-reg.sock",
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
            "--nodeid=$(NODE_ID)",
            "--endpoint=$(CSI_ENDPOINT)",
          ]
          command = ["/usr/local/bin/alluxio-csi"]

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
          image             = "registry.rebelsoft.com/alluxio-csi"
          image_pull_policy = "IfNotPresent"
          name              = "alluxio"
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
        }
        host_network    = true
        service_account = "csi-nodeplugin"

        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins/csi-alluxioplugin"
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
      }
    }
  }
}