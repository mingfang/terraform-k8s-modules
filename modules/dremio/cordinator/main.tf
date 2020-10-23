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
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.master.enabled=false -Dservices.executor.enabled=false"
          },
        ], var.env)

        liveness_probe = {
          http_get = {
            path   = "/apiv2/server_status"
            port   = "9047"
            scheme = "HTTP"
          }
          initial_delay_seconds = 30
          period_seconds        = 30
        }

        resources = var.resources

        volume_mounts = concat([
          {
            mount_path = "/opt/dremio/conf"
            name       = "config"
          },
        ], lookup(var.overrides, "volume_mounts", []))
      },
    ]

    init_containers = [
      {
        command = [
          "sh",
          "-c",
          "until nc -z ${var.master-cordinator} 9047 > /dev/null; do echo waiting for dremio master; sleep 2; done;",
        ]
        image = "busybox"
        name  = "wait-for-zk"
      },
    ]

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      }
    ]
  }

  volumes = concat(local.parameters.volumes, lookup(var.overrides, "volumes", []))

}


module "statefulset-service" {
  source = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides, {
    "volumes" = local.volumes
  })
}