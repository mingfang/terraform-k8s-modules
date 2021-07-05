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
        name  = "realtime"
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
            name  = "DB_HOST"
            value = var.DB_HOST
          },
          {
            name  = "DB_NAME"
            value = var.DB_NAME
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
            name  = "DB_PORT"
            value = var.DB_PORT
          },
          {
            name  = "PORT"
            value = var.ports[0].port
          },
          {
            name  = "HOSTNAME"
            value = var.HOSTNAME
          },
          {
            name  = "SECURE_CHANNELS"
            value = var.SECURE_CHANNELS
          },
          {
            name  = "JWT_SECRET"
            value = var.JWT_SECRET
          },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}