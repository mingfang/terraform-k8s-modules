

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
        name  = "memcached"
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
