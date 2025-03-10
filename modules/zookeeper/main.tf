locals {
  zoo-servers = join(" ",
    [
      for i in range(0, var.replicas) :
      "server.${i + 1}=${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:2888:3888;2181"
    ]
  )

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
        name  = "zookeeper"
        image = var.image

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
                divisor = "1Mi"
              }
            }
          },
          {
            name  = "ZOO_DATA_DIR"
            value = "/data"
          },
          {
            name  = "ZOO_SERVERS"
            value = local.zoo-servers
          },
          {
            name  = "ZOO_STANDALONE_ENABLED"
            value = var.replicas == 1 ? "true" : "false"
          },
          {
            name  = "ZOO_AUTOPURGE_PURGEINTERVAL"
            value = 1
          },
        ], var.env)

        command = [
          "bash",
          "-cx",
          <<-EOF
          echo "$(expr $${HOSTNAME//[^0-9]/} + 1)" > $ZOO_DATA_DIR/myid
          export ZOO_SERVERS=$(echo $ZOO_SERVERS|sed "s|$POD_NAME.${var.name}.${var.namespace}.svc.cluster.local|0.0.0.0|")
          /docker-entrypoint.sh zkServer.sh start-foreground
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 30

          exec = {
            command = [
              "/bin/bash",
              "-cx",
              "echo 'srvr' | nc localhost 2181 | grep Mode",
            ]
          }
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          },
        ]
      },
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          chown zookeeper /data
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          },
        ]
      },
    ]

    security_context = {
      fsgroup    = 1000
      run_asuser = 1000
    }

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}