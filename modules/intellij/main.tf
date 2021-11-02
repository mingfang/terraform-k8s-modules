locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = 1
    ports                = var.ports
    enable_service_links = false
    annotations          = var.annotations

    containers = concat([
      {
        name  = "intellij"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          cd /
          ./run.sh
          EOF
        ]

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
        ], var.env)

        startup_probe = {
          initial_delay_seconds = 30
          period_seconds        = 10
          failure_threshold     = 30

          http_get = {
            path = "/"
            port = var.ports[0].port
          }
        }

        liveness_probe = {
          initial_delay_seconds = 30
          period_seconds        = 10
          failure_threshold     = 3

          http_get = {
            path = "/"
            port = var.ports[0].port
          }
        }

        readiness_probe = {
          initial_delay_seconds = 30
          period_seconds        = 10
          failure_threshold     = 3

          http_get = {
            path = "/"
            port = var.ports[0].port
          }
        }

        resources = var.resources

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/home/projector-user"
          },
        ] : []
      }
    ], var.additional_containers)

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          chown projector-user /home/projector-user
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/home/projector-user"
          },
        ] : []
      },
    ]

    volumes = var.pvc != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc
        }
      },
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}