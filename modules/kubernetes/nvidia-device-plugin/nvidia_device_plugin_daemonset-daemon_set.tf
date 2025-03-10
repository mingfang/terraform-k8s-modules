resource "k8s_apps_v1_daemon_set" "nvidia_device_plugin_daemonset" {
  metadata {
    name      = "nvidia-device-plugin-daemonset"
    namespace = "kube-system"
  }
  spec {
    selector {
      match_labels = {
        "name" = "nvidia-device-plugin-ds"
      }
    }
    template {
      metadata {
        labels = {
          "name" = "nvidia-device-plugin-ds"
        }
      }
      spec {

        containers {

          env {
            name  = "FAIL_ON_INIT_ERROR"
            value = "false"
          }
          image = "nvcr.io/nvidia/k8s-device-plugin:v0.15.0"
          name  = "nvidia-device-plugin-ctr"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "ALL",
              ]
            }
          }

          volume_mounts {
            mount_path = "/var/lib/kubelet/device-plugins"
            name       = "device-plugin"
          }
        }

        node_selector = {
          "docker/runtime" = "nvidia"
        }
        
        priority_class_name = "system-node-critical"

        tolerations {
          effect   = "NoSchedule"
          key      = "nvidia.com/gpu"
          operator = "Exists"
        }

        volumes {
          host_path {
            path = "/var/lib/kubelet/device-plugins"
          }
          name = "device-plugin"
        }
      }
    }
    update_strategy {
      type = "RollingUpdate"
    }
  }
}