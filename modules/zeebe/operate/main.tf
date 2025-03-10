locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "operate"
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
            name  = "CAMUNDA_OPERATE_ELASTICSEARCH_URL"
            value = var.CAMUNDA_OPERATE_ELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_URL"
            value = var.CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_URL
          },
          {
            name  = "CAMUNDA_OPERATE_ZEEBE_GATEWAYADDRESS"
            value = var.CAMUNDA_OPERATE_ZEEBE_GATEWAYADDRESS
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
