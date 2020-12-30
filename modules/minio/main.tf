locals {
  servers = [
    for i in range(0, var.replicas) :
    "http://${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local/data/${var.name}-${i}"
  ]

  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "minio"
        image = var.image

        args = coalescelist(var.args, concat(["server"], local.servers))

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
            name  = "MINIO_ACCESS_KEY"
            value = var.minio_access_key
          },
          {
            name  = "MINIO_SECRET_KEY"
            value = var.minio_secret_key
          },
        ], var.env)

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          }
        ]
      },
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}