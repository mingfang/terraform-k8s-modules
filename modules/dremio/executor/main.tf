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
        name = "server"
        port = 45678
      },
    ]
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
            name  = "DREMIO_MAX_HEAP_MEMORY_SIZE_MB"
            value = "4096"
          },
          {
            name  = "DREMIO_MAX_DIRECT_MEMORY_SIZE_MB"
            value = "12288"
          },
          {
            name  = "DREMIO_JAVA_EXTRA_OPTS"
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.enabled=false"
          },
        ], var.env)

        resources = {
          requests = {
            cpu    = "4"
            memory = "16384M"
          }
        }

        volume_mounts = concat([
          {
            mount_path = "/opt/dremio/data"
            name       = var.volume_claim_template_name
          },
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
          "until ping -c 1 -W 1 ${var.zookeeper} > /dev/null; do echo waiting for zookeeper host; sleep 5; done;",
        ]
        image = "busybox"
        name  = "wait-for-zk"
      },
//      {
//        args = [
//          "dremio:dremio",
//          "/opt/dremio/data",
//        ]
//        command = [
//          "chown",
//        ]
//        image             = var.image
//        image_pull_policy = "IfNotPresent"
//        name              = "chown-data-directory"
//
//        security_context = {
//          privileged = true
//          runAsUser = 0
//      }
//
//        volume_mounts = [
//          {
//            mount_path = "/opt/dremio/data"
//            name       = var.volume_claim_template_name
//          },
//        ]
//      },
    ]

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      }
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
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides, {"volumes" = local.volumes})
}