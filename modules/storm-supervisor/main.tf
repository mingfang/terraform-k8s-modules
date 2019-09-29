/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name = var.name
    namespace = var.namespace
    replicas = var.replicas
    ports = [
      {
        name = "http"
        port = var.port
      }
    ]
    containers = [
      {
        name = "nginx"
        image = var.image

        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
        ]

        liveness_probe = {
          failure_threshold = 3
          initial_delay_seconds = 60
          period_seconds = 10
          success_threshold = 1
          timeout_seconds = 1

          http_get = {
            path = "/status"
            port = var.port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold = 3
          initial_delay_seconds = 5
          period_seconds = 10
          success_threshold = 1
          timeout_seconds = 1

          http_get = {
            path = "/status"
            port = var.port
            scheme = "HTTP"
          }
        }
      }
    ]
  }
}


module "deployment-service" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
