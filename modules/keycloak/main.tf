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
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "keycloak"
        image = var.image

        env = concat([
          {
            name       = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "KEYCLOAK_USER"
            value = var.KEYCLOAK_USER
          },
          {
            name  = "KEYCLOAK_PASSWORD"
            value = var.KEYCLOAK_PASSWORD
          },
          {
            name  = "DB_VENDOR"
            value = var.DB_VENDOR
          },
          {
            name  = "DB_ADDR"
            value = var.DB_ADDR
          },
          {
            name  = "DB_PORT"
            value = var.DB_PORT
          },
          {
            name  = "DB_USER"
            value = var.DB_USER
          },
          {
            name  = "DB_PASSWORD"
            value = var.DB_PASSWORD
          },
          {
            name  = "DB_SCHEMA"
            value = var.DB_SCHEMA
          },
          {
            name  = "PROXY_ADDRESS_FORWARDING"
            value = var.PROXY_ADDRESS_FORWARDING
          },
        ], var.env, local.computed_env)

        env_from = var.env_from

        lifecycle = var.post_start_command  != null ? {
          post_start = {
            exec = {
              command = var.post_start_command
            }
          }
        } : null

        liveness_probe = {
          http_get = {
            path = "/"
            port = var.ports[0].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }

        resources = var.resources
      },
    ]

    node_selector = var.node_selector
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}