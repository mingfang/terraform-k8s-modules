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
    replicas  = var.replicas
    ports     = var.ports

    containers = [
      {
        name  = "zetcd"
        image = var.image
        command = [
          "sh",
          "-c",
          <<-EOF
          zetcd --zkaddr 0.0.0.0:2181 --endpoints ${var.etcd}
          EOF
        ]
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
