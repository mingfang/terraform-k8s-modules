resource "k8s_apps_v1_deployment" "csi_cephfsplugin_provisioner" {
  metadata {
    name      = "csi-cephfsplugin-provisioner"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "csi-cephfsplugin-provisioner"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "csi-cephfsplugin-provisioner"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {

            required_during_scheduling_ignored_during_execution {
              label_selector {

                match_expressions {
                  key      = "app"
                  operator = "In"
                  values = [
                    "csi-cephfsplugin-provisioner",
                  ]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        containers {
          args = [
            "--nodeid=$(NODE_ID)",
            "--type=cephfs",
            "--controllerserver=true",
            "--endpoint=$(CSI_ENDPOINT)",
            "--v=5",
            "--drivername=cephfs.csi.ceph.com",
            "--pidlimit=-1",
            "--enableprofiling=false",
            "--setmetadata=true",
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
            value = "unix:///csi/csi-provisioner.sock"
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

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
          volume_mounts {
            mount_path = "/sys"
            name       = "host-sys"
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
            mount_path = "/etc/ceph-csi-encryption-kms-config/"
            name       = "ceph-csi-encryption-kms-config"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=1",
            "--timeout=150s",
            "--leader-election=true",
            "--retry-interval-start=500ms",
            "--feature-gates=HonorPVReclaimPolicy=true",
            "--prevent-volume-mode-conversion=true",
            "--extra-create-metadata=true",
          ]

          env {
            name  = "ADDRESS"
            value = "unix:///csi/csi-provisioner.sock"
          }
          image             = "registry.k8s.io/sig-storage/csi-provisioner:v5.0.1"
          image_pull_policy = "IfNotPresent"
          name              = "csi-provisioner"

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=1",
            "--timeout=150s",
            "--leader-election",
            "--retry-interval-start=500ms",
            "--handle-volume-inuse-error=false",
            "--feature-gates=RecoverVolumeExpansionFailure=true",
          ]

          env {
            name  = "ADDRESS"
            value = "unix:///csi/csi-provisioner.sock"
          }
          image             = "registry.k8s.io/sig-storage/csi-resizer:v1.11.1"
          image_pull_policy = "IfNotPresent"
          name              = "csi-resizer"

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        containers {
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=1",
            "--timeout=150s",
            "--leader-election=true",
            "--extra-create-metadata=true",
            "--enable-volume-group-snapshots=true",
          ]

          env {
            name  = "ADDRESS"
            value = "unix:///csi/csi-provisioner.sock"
          }
          image             = "registry.k8s.io/sig-storage/csi-snapshotter:v8.0.1"
          image_pull_policy = "IfNotPresent"
          name              = "csi-snapshotter"

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
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
            value = "unix:///csi/csi-provisioner.sock"
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

          volume_mounts {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        priority_class_name  = "system-cluster-critical"
        service_account_name = "cephfs-csi-provisioner"

        volumes {
          empty_dir {
            medium = "Memory"
          }
          name = "socket-dir"
        }
        volumes {
          host_path {
            path = "/sys"
          }
          name = "host-sys"
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
          config_map {
            name = "ceph-csi-encryption-kms-config"
          }
          name = "ceph-csi-encryption-kms-config"
        }
      }
    }
  }
}