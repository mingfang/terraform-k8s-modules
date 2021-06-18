locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "dagster-daemon"
        image = var.image
        command = [
          "/bin/bash",
          "-cx",
          <<-EOF
          dagster-daemon run
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
            name  = "DAGSTER_HOME"
            value = "/opt/dagster/dagster_home"
          },
        ], var.env)

        startup_probe = {
          exec = {
            command = [
              "dagster-daemon",
              "liveness-check",
            ]
          }
          failure_threshold = 12
          period_seconds    = 10
          timeout_seconds   = 3
        }

        liveness_probe = {
          exec = {
            command = [
              "dagster-daemon",
              "liveness-check",
            ]
          }
          failure_threshold = 3
          period_seconds    = 30
          timeout_seconds   = 3
        }

        volume_mounts = [
          {
            mount_path = "/opt/dagster/dagster_home/dagster.yaml"
            name       = "dagster-instance"
            sub_path   = "dagster.yaml"
          },
        ]
      }
    ]

    service_account_name = module.rbac.name

    volumes = [
      {
        config_map = {
          name = var.config_map_dagster
        }
        name = "dagster-instance"
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
