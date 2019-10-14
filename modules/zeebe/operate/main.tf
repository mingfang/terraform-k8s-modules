/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

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
            name  = "CAMUNDA_OPERATE_ELASTICSEARCH_HOST"
            value = var.CAMUNDA_OPERATE_ELASTICSEARCH_HOST
          },
          {
            name  = "CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST"
            value = var.CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST
          },
          {
            name  = "CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT"
            value = var.CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT
          },
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
