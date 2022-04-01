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

        args = coalescelist(var.args, concat(["server", "--console-address", ":${var.ports[1].port}"], local.servers))

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
            name  = "MINIO_ROOT_USER"
            value = var.minio_access_key
          },
          {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.minio_secret_key
          },
        ], var.env)

        liveness_probe = {
          failure_threshold = 3
          http_get = {
            path   = "/minio/health/live"
            port   = var.ports[0].port
            scheme = "HTTP"
          }
          initial_delay_seconds = 60
          period_seconds        = 30
          success_threshold     = 1
          timeout_seconds       = 20
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          }
        ]
      },
      {
        name    = "mc"
        image   = "minio/mc"
        command = ["sleep", "infinity"]

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
            name  = "MINIO_ROOT_USER"
            value = var.minio_access_key
          },
          {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.minio_secret_key
          },
        ], var.env)
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