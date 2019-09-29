/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    ports = [
      {
        name = "http"
        port = 80
      },
    ]
    containers = [
      {
        name  = "proxy"
        image = var.image
        args = [
          "${var.master_host}:${var.master_port}"
        ]
      },
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
