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
        name  = "contextionary"
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
            name  = "OCCURRENCE_WEIGHT_LINEAR_FACTOR"
            value = var.OCCURRENCE_WEIGHT_LINEAR_FACTOR
          },
          {
            name  = "EXTENSIONS_STORAGE_MODE"
            value = var.EXTENSIONS_STORAGE_MODE
          },
          {
            name  = "EXTENSIONS_STORAGE_ORIGIN"
            value = var.EXTENSIONS_STORAGE_ORIGIN
          },
          {
            name  = "NEIGHBOR_OCCURRENCE_IGNORE_PERCENTILE"
            value = var.NEIGHBOR_OCCURRENCE_IGNORE_PERCENTILE
          },
          {
            name  = "ENABLE_COMPOUND_SPLITTING"
            value = var.ENABLE_COMPOUND_SPLITTING
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