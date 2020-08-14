terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

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
            value = "-Dzookeeper=${var.zookeeper} -Dservices.coordinator.master.embedded-zookeeper.enabled=false -Dservices.executor.enabled=false ${var.extra_args}"
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
            name       = "config"
            mount_path = "/opt/dremio/conf"
          },
          {
            name       = "data"
            mount_path = "/opt/dremio/data"
          },
        ], lookup(var.overrides, "volume_mounts", []))
      },
    ]

    init_containers = [
      {
        name  = "start-only-one-master"
        image = "busybox"
        command = [
          "sh",
          "-cx",
          "INDEX=$${HOSTNAME##*-}; if [ $INDEX -ne 0 ]; then echo Only one master should be running.; exit 1; fi; ",
        ]
      },
      {
        name  = "wait-for-zk"
        image = "busybox"
        command = [
          "sh",
          "-cx",
          "until ping -c 1 -W 1 ${var.zookeeper} > /dev/null; do echo waiting for zookeeper host; sleep 2; done;",
        ]
      },
      {
        name  = "chown"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          chown dremio:dremio /opt/dremio/data
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/opt/dremio/data"
          },
        ]
      },
      {
        name              = "upgrade"
        image             = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          /opt/dremio/bin/dremio-admin upgrade
          EOF
        ]

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/opt/dremio/data"
          }
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
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
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