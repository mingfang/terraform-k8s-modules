resource "k8s_apps_v1_daemon_set" "csi_cephfsplugin" {
  metadata {
    name      = "csi-cephfsplugin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        "app" = "csi-cephfsplugin"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "csi-cephfsplugin"
        }
      }
      spec {

        containers {
          args = [
            "--nodeid=$(NODE_ID)",
            "--type=cephfs",
            "--nodeserver=true",
            "--endpoint=$(CSI_ENDPOINT)",
            "--v=5",
            "--drivername=cephfs.csi.ceph.com",
            "--enableprofiling=false",
          ]

          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
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
            value = "unix:///csi/csi.sock"
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/cephcsi/cephcsi:canary"
          image_pull_policy = "IfNotPresent"
          name              = "csi-cephfsplugin"
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
            mount_path = "/csi"
            name       = "socket-dir"
          }
          volume_mounts {
            mount_path        = "/var/lib/kubelet/pods"
            mount_propagation = "Bidirectional"
            name              = "mountpoint-dir"
          }
          volume_mounts {
            mount_path        = "/var/lib/kubelet/plugins"
            mount_propagation = "Bidirectional"
            name              = "plugin-dir"
          }
          volume_mounts {
            mount_path = "/sys"
            name       = "host-sys"
          }
          volume_mounts {
            mount_path = "/etc/selinux"
            name       = "etc-selinux"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/lib/modules"
            name       = "lib-modules"
            read_only  = true
          }
          volume_mounts {
            mount_path = "/dev"
            name       = "host-dev"
          }
          volume_mounts {
            mount_path = "/run/mount"
            name       = "host-mount"
          }
          volume_mounts {
            mount_path = "/etc/ceph/"
            name       = "ceph-config"
          }
          volume_mounts {
            mount_path = "/etc/ceph-csi-config/"
            name       = "ceph-csi-config"
          }
          volume_mounts {
            mount_path = "/tmp/csi/keys"
            name       = "keys-tmp-dir"
          }
          volume_mounts {
            mount_path = "/csi/mountinfo"
            name       = "ceph-csi-mountinfo"
          }
          volume_mounts {
            mount_path = "/etc/ceph-csi-encryption-kms-config/"
            name       = "ceph-csi-encryption-kms-config"
          }
        }
        containers {
          args = [
            "--v=1",
            "--csi-address=/csi/csi.sock",
            "--kubelet-registration-path=/var/lib/kubelet/plugins/cephfs.csi.ceph.com/csi.sock",
          ]

          env {
            name = "KUBE_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          image = "registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.1"
          name  = "driver-registrar"
          security_context {
            allow_privilege_escalation = true
            privileged                 = true
          }

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
          volume_mounts {
            mount_path = "/registration"
            name       = "registration-dir"
          }
        }
        containers {
          args = [
            "--type=liveness",
            "--endpoint=$(CSI_ENDPOINT)",
            "--metricsport=8681",
            "--metricspath=/metrics",
            "--polltime=60s",
            "--timeout=3s",
          ]

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///csi/csi.sock"
          }
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          image             = "quay.io/cephcsi/cephcsi:canary"
          image_pull_policy = "IfNotPresent"
          name              = "liveness-prometheus"
          security_context {
            allow_privilege_escalation = true
            privileged                 = true
          }

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        dns_policy           = "ClusterFirstWithHostNet"
        host_network         = true
        host_pid             = true
        priority_class_name  = "system-node-critical"
        service_account_name = "cephfs-csi-nodeplugin"

        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins/cephfs.csi.ceph.com/"
            type = "DirectoryOrCreate"
          }
          name = "socket-dir"
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
            path = "/var/lib/kubelet/pods"
            type = "DirectoryOrCreate"
          }
          name = "mountpoint-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins"
            type = "Directory"
          }
          name = "plugin-dir"
        }
        volumes {
          host_path {
            path = "/sys"
          }
          name = "host-sys"
        }
        volumes {
          host_path {
            path = "/etc/selinux"
          }
          name = "etc-selinux"
        }
        volumes {
          host_path {
            path = "/lib/modules"
          }
          name = "lib-modules"
        }
        volumes {
          host_path {
            path = "/dev"
          }
          name = "host-dev"
        }
        volumes {
          host_path {
            path = "/run/mount"
          }
          name = "host-mount"
        }
        volumes {
          config_map {
            name = "ceph-config"
          }
          name = "ceph-config"
        }
        volumes {
          config_map {
            name = "ceph-csi-config"
          }
          name = "ceph-csi-config"
        }
        volumes {
          empty_dir {
            medium = "Memory"
          }
          name = "keys-tmp-dir"
        }
        volumes {
          host_path {
            path = "/var/lib/kubelet/plugins/cephfs.csi.ceph.com/mountinfo"
            type = "DirectoryOrCreate"
          }
          name = "ceph-csi-mountinfo"
        }
        volumes {
          config_map {
            name = "ceph-csi-encryption-kms-config"
          }
          name = "ceph-csi-encryption-kms-config"
        }
      }
    }
  }
}