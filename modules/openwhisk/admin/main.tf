locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas

    enable_service_links = false

    containers = [
      {
        name  = "admin"
        image = var.image
        command = [
          "/bin/bash",
          "-c",
          <<-EOF
          wsk property set --apihost $API_HOST --auth $AUTH_KEY
          tail -f /dev/null
          EOF
        ]
        env = concat([
          {
            name  = "WHISK_LOGS_DIR"
            value = "/var/log"
          },
          {
            name = "API_HOST"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_url"
                name = var.whisk_config_name
              }
            }
          },
          {
            name = "AUTH_KEY"
            value_from = {
              secret_key_ref = {
                key  = "system"
                name = var.whisk_secret_name
              }
            }
          },
          {
            name = "DB_HOST"
            value_from = {
              config_map_keyref = {
                key  = "db_host"
                name = var.db_config_name
              }
            }
          },
          {
            name = "DB_PROTOCOL"
            value_from = {
              config_map_keyref = {
                key  = "db_protocol"
                name = var.db_config_name
              }
            }
          },
          {
            name = "DB_PORT"
            value_from = {
              config_map_keyref = {
                key  = "db_port"
                name = var.db_config_name
              }
            }
          },
          {
            name = "DB_USERNAME"
            value_from = {
              secret_key_ref = {
                key  = "db_username"
                name = var.db_secret_name
              }
            }
          },
          {
            name = "DB_PASSWORD"
            value_from = {
              secret_key_ref = {
                key  = "db_password"
                name = var.db_secret_name
              }
            }
          },
          {
            name = "DB_WHISK_ACTIONS"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_actions"
                name = var.db_config_name
              }
            }
          },
          {
            name = "DB_WHISK_AUTHS"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_auths"
                name = var.db_config_name
              }
            }
          },
          {
            name = "DB_WHISK_ACTIVATIONS"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_activations"
                name = var.db_config_name
              }
            }
          }
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
