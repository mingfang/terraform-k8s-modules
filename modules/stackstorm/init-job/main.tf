resource "k8s_batch_v1_job" "init" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
  }

  spec {
    template {
      spec {
        containers {
          name  = "init"
          image = var.image

          command = [
            "sh",
            "-cx",
            <<-EOF
            st2-apply-rbac-definitions --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf

            rsync -av /opt/stackstorm/packs/ /tmp/shared/packs
            st2-register-content --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf --register-all
            EOF
          ]
          volume_mounts {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
          }
          volume_mounts {
            name       = "config-rbac-assignments"
            mount_path = "/opt/stackstorm/rbac/assignments"
          }
          volume_mounts {
            name       = "stackstorm-packs-configs"
            mount_path = "/opt/stackstorm/configs"
          }
          volume_mounts {
            name       = "stackstorm-packs"
            mount_path = "/tmp/shared/packs"
          }
        }

        restart_policy = "OnFailure"

        volumes {
          name = "config"

          config_map {
            name = var.config_map
          }
        }
        volumes {
          name = "config-rbac-assignments"

          config_map {
            name = var.config_map_rbac_assignments
          }
        }
        volumes {
          name = "stackstorm-packs-configs"

          persistent_volume_claim {
            claim_name = var.stackstorm_packs_configs_pvc_name
          }
        }
        volumes {
          name = "stackstorm-packs"

          persistent_volume_claim {
            claim_name = var.stackstorm_packs_pvc_name
          }
        }
      }
    }
  }
}

