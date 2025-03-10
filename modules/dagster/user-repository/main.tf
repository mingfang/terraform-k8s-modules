locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name    = var.name
        image = var.image
        command = var.command
        args    = var.args

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
        ], var.env, local.computed_env)

        env_from = var.env_from

        resources = var.resources

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

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

    node_selector        = var.node_selector
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
