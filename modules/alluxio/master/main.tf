/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  alluxio_java_opts = join(" ", [
    "-Dalluxio.master.port=${var.ports.0.port}",
    var.extra_alluxio_java_opts
  ])

  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports = var.ports
    enable_service_links = false
    containers = [
      {
        name  = "alluxio"
        image = var.image

        args = [
          "master"
        ]

        env = [
          {
            name = "ALLUXIO_JAVA_OPTS"
            value = local.alluxio_java_opts
          },
        ]
      }
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
