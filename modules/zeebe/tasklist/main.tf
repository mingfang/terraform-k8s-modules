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
        name  = "tasklist"
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
            name  = "CAMUNDA_TASKLIST_ELASTICSEARCH_URL"
            value = var.CAMUNDA_TASKLIST_ELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_TASKLIST_ZEEBEELASTICSEARCH_URL"
            value = var.CAMUNDA_TASKLIST_ZEEBEELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_TASKLIST_ZEEBE_GATEWAYADDRESS"
            value = var.CAMUNDA_TASKLIST_ZEEBE_GATEWAYADDRESS
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
