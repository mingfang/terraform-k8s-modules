/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
    replicas  = var.replicas
    ports     = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "nginx"
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
          failure_threshold     = 3
          initial_delay_seconds = 60
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/status"
            port   = var.ports[0].port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 5
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/status"
            port   = var.ports[0].port
            scheme = "HTTP"
          }
        }
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
