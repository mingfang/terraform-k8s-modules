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
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "wordpress"
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
            name  = "WORDPRESS_DB_HOST"
            value = var.WORDPRESS_DB_HOST
          },
          {
            name  = "WORDPRESS_DB_USER"
            value = var.WORDPRESS_DB_USER
          },
          {
            name  = "WORDPRESS_DB_PASSWORD"
            value = var.WORDPRESS_DB_PASSWORD
          },
          {
            name  = "WORDPRESS_DB_NAME"
            value = var.WORDPRESS_DB_NAME
          },
          {
            name  = "WORDPRESS_TABLE_PREFIX"
            value = var.WORDPRESS_TABLE_PREFIX
          },
          {
            name  = "WORDPRESS_DEBUG"
            value = var.WORDPRESS_DEBUG
          },
          {
            name  = "WORDPRESS_CONFIG_EXTRA"
            value = var.WORDPRESS_CONFIG_EXTRA
          },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
