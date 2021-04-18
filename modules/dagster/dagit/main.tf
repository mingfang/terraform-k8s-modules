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
        name  = "dagit"
        image = var.image
        command = [
          "/bin/bash",
          "-cx",
          <<-EOF
          dagit -h 0.0.0.0 -p ${var.ports[0].port} -w $DAGSTER_HOME/workspace/workspace.yaml
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

        env_from = [
          {
            config_map_ref = {
              name = var.config_map_env
            }
          },
        ]

        startup_probe = {
          http_get = {
            path = "/dagit_info"
            port = var.ports[0].port
          }
          initial_delay_seconds = 1
          success_threshold     = 1
          failure_threshold     = 12
          period_seconds        = 10
          timeout_seconds       = 3
        }

        liveness_probe = {
          http_get = {
            path = "/dagit_info"
            port = var.ports[0].port
          }
          success_threshold = 1
          failure_threshold = 3
          period_seconds    = 20
          timeout_seconds   = 3
        }

        volume_mounts = [
          {
            mount_path = "/opt/dagster/dagster_home/dagster.yaml"
            name       = "dagster-instance"
            sub_path   = "dagster.yaml"
          },
          {
            mount_path = "/opt/dagster/dagster_home/workspace"
            name       = "dagster-workspace-yaml"
          },
        ]
      }
    ]

    service_account_name = var.service_account_name

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "dagster-instance"
      },
      {
        config_map = {
          name = var.config_map_workspace
        }
        name = "dagster-workspace-yaml"
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
