locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "postgrest"
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "PGRST_DB_URI"
            value = var.PGRST_DB_URI
          },
          {
            name  = "PGRST_DB_SCHEMA"
            value = var.PGRST_DB_SCHEMA
          },
          {
            name  = "PGRST_DB_ANON_ROLE"
            value = var.PGRST_DB_ANON_ROLE
          },
          {
            name  = "PGRST_JWT_SECRET"
            value = var.PGRST_JWT_SECRET
          },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}