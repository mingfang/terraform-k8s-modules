/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports = [
      {
        name = "http"
        port = 9047
      },
      {
        name = "client"
        port = 31010
      },
      {
        name = "server"
        port = 45678
      },
    ]
    containers = [
      {
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
            name  = "DREMIO_MAX_HEAP_MEMORY_SIZE_MB"
            value = "4096"
          },
          {
            name  = "DREMIO_MAX_DIRECT_MEMORY_SIZE_MB"
            value = "12288"
          },
          {
            name  = "DREMIO_JAVA_EXTRA_OPTS"
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.master.enabled=false -Dservices.executor.enabled=false"
          },
        ], var.env)

        image = var.image
        name  = "dremio"

        resources = {
          requests = {
            cpu    = "4"
            memory = "16384M"
          }
        }

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
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides, {"volumes" = local.volumes})
}