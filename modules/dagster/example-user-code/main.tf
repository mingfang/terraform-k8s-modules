locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "example-user-code"
        image = var.image
        command = [
          "/bin/bash",
          "-cx",
          <<-EOF
          dagster api grpc -h 0.0.0.0 -p ${var.ports[0].port} -f /example_project/example_repo/repo.py
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
            name  = "DAGSTER_CURRENT_IMAGE"
            value = var.image
          },
        ], var.env)

        startup_probe = {
          exec = {
            command = [
              "dagster",
              "api",
              "grpc-health-check",
              "-p",
              var.ports[0].port,
            ]
          }
          failure_threshold     = 3
          initial_delay_seconds = 0
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 3
        }

        liveness_probe = {
          exec = {
            command = [
              "dagster",
              "api",
              "grpc-health-check",
              "-p",
              var.ports[0].port,
            ]
          }
          failure_threshold     = 3
          initial_delay_seconds = 0
          period_seconds        = 20
          success_threshold     = 1
          timeout_seconds       = 3
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
