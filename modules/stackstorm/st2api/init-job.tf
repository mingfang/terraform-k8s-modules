resource "k8s_batch_v1_job" "init" {
  metadata {
    name      = var.name
    namespace = var.namespace
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
            cp -r /opt/stackstorm/packs/* /tmp/shared/packs
            st2-register-content --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf --register-all
            EOF
          ]
          volume_mounts {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
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
          name = "stackstorm-packs"

          persistent_volume_claim {
            claim_name = var.stackstorm_packs_pvc_name
          }
        }
      }
    }
  }
}

