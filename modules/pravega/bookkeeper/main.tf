locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "bookie"
        image = var.image
        env = concat([
          {
            name  = "ZK_URL"
            value = var.ZK_URL
          },
          {
            name  = "bookiePort"
            value = var.ports[0].port
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = var.pvc
            mount_path = "/bk"
          },
        ]
      },
    ]

    volume_claim_templates = [
      {
        name               = var.pvc
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}