locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "optimize"
        image = var.image

        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "CAMUNDA_OPTIMIZE_ELASTICSEARCH_URL"
            value = var.CAMUNDA_OPTIMIZE_ELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_OPTIMIZE_ZEEBEELASTICSEARCH_URL"
            value = var.CAMUNDA_OPTIMIZE_ZEEBEELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_OPTIMIZE_ZEEBE_GATEWAYADDRESS"
            value = var.CAMUNDA_OPTIMIZE_ZEEBE_GATEWAYADDRESS
          },
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
