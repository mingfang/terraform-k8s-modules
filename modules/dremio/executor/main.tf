locals {
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
        name  = "dremio"
        image = var.image

        args = [
          "start-fg",
        ]
        command = [
          "/opt/dremio/bin/dremio",
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
          {
            name = "LIMITS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name  = "DREMIO_MAX_MEMORY_SIZE_MB"
            value = "$(REQUESTS_MEMORY)"
          },
          {
            name  = "DREMIO_JAVA_EXTRA_OPTS"
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.enabled=false"
          },
        ], var.env)

        resources = var.resources

        volume_mounts = concat([
          {
            name       = "config"
            mount_path = "/opt/dremio/conf"
          },
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/dremio/data/pdfs"
          },
        ], lookup(var.overrides, "volume_mounts", []))
      },
    ]

    init_containers = [
      {
        name  = "wait-for-zk"
        image = "busybox"
        command = [
          "sh",
          "-cx",
          "until ping -c 1 -W 1 ${var.zookeeper} > /dev/null; do echo waiting for zookeeper host; sleep 5; done;",
        ]
        image = "busybox"
        name  = "wait-for-zk"
      },
      {
        name              = "chown"
        image             = var.image
        command = ["chown"]
        args = ["dremio:dremio", "/opt/dremio/data/pdfs"]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/dremio/data/pdfs"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "config"
        config_map = {
          name = var.config_map
        }
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

  volumes = concat(local.parameters.volumes, lookup(var.overrides, "volumes", []))

}


module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides, {
    "volumes" = local.volumes
  })
}