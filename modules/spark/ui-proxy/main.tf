locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations =  var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "proxy"
        image = var.image
        args = [
          "${var.master_host}:${var.master_port}"
        ]
        env = var.env
      },
    ]
  }
}


module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}