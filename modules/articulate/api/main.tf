/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "api"
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
            name  = "NODE_ENV"
            value = "production"
          },
        ], var.env)

        command = [
          "sh",
          "-cx",
          <<-EOF
          dockerize -wait ${var.elasticsearch} -timeout 5m yarn start
          EOF
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
