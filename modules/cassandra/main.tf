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
        name  = "cassandra"
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
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
            name  = "MAX_HEAP_SIZE"
            value = "$(REQUESTS_MEMORY)M"
          },
          {
            name  = "HEAP_NEWSIZE"
            value = "100M"
          },
          {
            name  = "CASSANDRA_LISTEN_ADDRESS"
            value = "$(POD_IP)"
          },
          {
            name  = "CASSANDRA_CLUSTER_NAME"
            value = var.CASSANDRA_CLUSTER_NAME
          },
          {
            name  = "CASSANDRA_DC"
            value = var.CASSANDRA_DC
          },
          {
            name  = "CASSANDRA_RACK"
            value = var.CASSANDRA_RACK
          },
          {
            name  = "CASSANDRA_ENDPOINT_SNITCH"
            value = var.CASSANDRA_ENDPOINT_SNITCH
          },
          {
            name  = "CASSANDRA_SEEDS"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "CASSANDRA_NUM_TOKENS"
            value = var.CASSANDRA_NUM_TOKENS
          }
        ], var.env)

        lifecycle = {
          pre_stop = {
            exec = {
              command = ["/bin/sh", "-c", "nodetool drain"]
            }
          }
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/var/lib/cassandra"
          }
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
          sysctl -w vm.max_map_count=1048575
          EOF
        ]

        security_context = {
          privileged = true
          run_asuser = "0"
        }
      },
    ]

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