locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name    = "datacoord"
        image   = var.image
        command = ["milvus", "run", "datacoord"]

        env = concat([
          {
            name  = "ETCD_ENDPOINTS"
            value = var.ETCD_ENDPOINTS
          },
          {
            name  = "MINIO_ADDRESS"
            value = var.MINIO_ADDRESS
          },
          {
            name  = "MINIO_ACCESS_KEY"
            value = var.MINIO_ACCESS_KEY
          },
          {
            name  = "MINIO_SECRET_KEY"
            value = var.MINIO_SECRET_KEY
          },
          {
            name  = "PULSAR_ADDRESS"
            value = var.PULSAR_ADDRESS
          },
          {
            name  = "DATA_COORD_ADDRESS"
            value = "${var.name}.${var.namespace}:${var.ports[0].port}"
          },
        ], var.env)

        resources = var.resources
      },
    ]

    node_selector = var.node_selector
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}