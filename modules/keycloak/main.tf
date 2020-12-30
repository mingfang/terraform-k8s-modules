

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
            name = "POD_NAME"

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
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
