

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = 1
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
            name  = "DREMIO_MAX_HEAP_MEMORY_SIZE_MB"
            value = "4096"
          },
          {
            name  = "DREMIO_MAX_DIRECT_MEMORY_SIZE_MB"
            value = "12288"
          },
          {
            name  = "DREMIO_JAVA_EXTRA_OPTS"
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.master.embedded-zookeeper.enabled=false -Dservices.executor.enabled=false"
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
          "INDEX=$${HOSTNAME##*-}; if [ $INDEX -ne 0 ]; then echo Only one master should be running.; exit 1; fi; ",
        ]
        image = "busybox"
        name  = "start-only-one-master"
      },
      {
        command = [
          "sh",
          "-c",
          "until ping -c 1 -W 1 ${var.zookeeper} > /dev/null; do echo waiting for zookeeper host; sleep 2; done;",
        ]
        image = "busybox"
        name  = "wait-for-zk"
      },
      {
        args = [
          "dremio:dremio",
          "/opt/dremio/data",
        ]
        command = [
          "chown",
        ]
        image             = var.image
        image_pull_policy = "IfNotPresent"
        name              = "chown-data-directory"

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/dremio/data"
          },
        ]
      },
      {
        args = [
          "upgrade",
        ]
        command = [
          "/opt/dremio/bin/dremio-admin",
        ]
        image             = var.image
        image_pull_policy = "IfNotPresent"
        name              = "upgrade-task"

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/dremio/data"
          }
        ]
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
  parameters = merge(local.parameters, var.overrides, { "volumes" = local.volumes })
}