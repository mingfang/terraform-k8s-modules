/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
    replicas  = var.replicas
    ports     = var.ports

    enable_service_links = false

    containers = [
      {
        name  = "dashboard"
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
            name  = "SERVICE_URL"
            value = var.SERVICE_URL
          }
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
