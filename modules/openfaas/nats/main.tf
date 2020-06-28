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
        name  = "nats"
        image = var.image
        args = [
          "--store",
          "memory",
          "--cluster_id",
          var.cluster_id,
          "-m",
          "8222",
        ]

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
        ], var.env)

        resources = var.resources
      },
      {
        name  = "metrics"
        image = var.metrics_image
        args = [
          "-port",
          "7777",
          "-connz",
          "-routez",
          "-subz",
          "-varz",
          "-channelz",
          "-serverz",
          "http://localhost:8222",
        ]
      },
    ]
  }

  podAnnotations = {
    "prometheus.io.scrape" = "true"
    "prometheus.io.port"   = 7777
  }
}


module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
  podAnnotations = local.podAnnotations
}