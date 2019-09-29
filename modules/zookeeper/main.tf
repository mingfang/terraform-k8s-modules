/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

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
            name  = "ZOO_DATA_DIR"
            value = "/data/$(POD_NAME)"
          },
          {
            name  = "ZOO_SERVERS"
            value = "${join(" ", data.template_file.zoo-servers.*.rendered)}"
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
          "-cex",
          <<-EOF
          export ZOO_SERVERS=$(echo $ZOO_SERVERS|sed "s|$POD_NAME.${var.name}.${var.namespace}|0.0.0.0|")
          /docker-entrypoint.sh zkServer.sh start-foreground
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 10

          exec = {
            command = [
              "/bin/bash",
              "-cx",
              "echo 'srvr' | nc localhost 2181 | grep Mode",
            ]
          }
        }

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
        ]
      },
    ]

    init_containers = [
      {
        name  = "set-myid"
        image = var.image

        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "ZOO_DATA_DIR"
            value = "/data/$(POD_NAME)"
          },
        ]

        command = [
          "bash",
          "-cex",
          "mkdir -p $ZOO_DATA_DIR; echo \"$(expr $${HOSTNAME//[^0-9]/} + 1)\" > $ZOO_DATA_DIR/myid",
        ]

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
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
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

data "template_file" "zoo-servers" {
  count    = var.replicas
  template = "server.${count.index + 1}=${var.name}-${count.index}.${var.name}.${var.namespace}:2888:3888;2181"
}