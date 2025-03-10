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
        name  = "worker"
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
            name  = "ZEEBE_CLIENT_BROKER_CONTACTPOINT"
            value = var.ZEEBE_CLIENT_BROKER_CONTACTPOINT
          },
          {
            name  = "ZEEBE_CLIENT_SECURITY_PLAINTEXT"
            value = var.ZEEBE_CLIENT_SECURITY_PLAINTEXT
          },
          {
            name  = "ZEEBE_WORKER_DEFAULTNAME"
            value = var.ZEEBE_WORKER_DEFAULTNAME
          },
          {
            name  = "ZEEBE_WORKER_DEFAULTTYPE"
            value = var.ZEEBE_WORKER_DEFAULTTYPE
          },
        ], var.env)
      }
    ]
  }
}


module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
