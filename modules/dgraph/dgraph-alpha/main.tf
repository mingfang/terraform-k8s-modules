/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "alpha"
        image = var.image

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
            name = "POD_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)

        command = [
          "bash",
          "-cx",
          <<-EOF
          exec dgraph alpha --my=$(hostname -f):7080 --lru_mb 2048 --zero ${var.peer}
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 15
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 6
          success_threshold     = 1

          http_get = {
            path   = "/health?live=1"
            port   = 8080
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          initial_delay_seconds = 15
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 6
          success_threshold     = 1

          http_get = {
            path   = "/health"
            port   = 8080
            scheme = "HTTP"
          }
        }

        volume_mounts = var.storage != null ? [
          {
            name          = var.volume_claim_template_name
            mount_path    = "/dgraph"
            sub_path_expr = "${var.name}/$(POD_NAME)"
          }
        ] : []
      },
    ]

    volume_claim_templates = var.storage != null ? [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}