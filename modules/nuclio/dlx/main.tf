locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = var.name
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
            name = "NUCLIO_RESOURCESCALER_FUNCTION_READINESS_VERIFICATION_ENABLED"
            value = "true"
          },
        ], var.env)

        resources = var.resources
      },
    ]

    node_selector = var.node_selector
    service_account_name = var.service_account_name
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}