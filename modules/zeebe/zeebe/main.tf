locals {
  contact-points = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:26502"
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
        name  = "zeebe"
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
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
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
            name  = "ZEEBE_BROKER_NETWORK_ADVERTISEDHOST"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "ZEEBE_BROKER_CLUSTER_INITIALCONTACTPOINTS"
            value = local.contact-points
          },
          {
            name  = "ZEEBE_BROKER_CLUSTER_CLUSTERSIZE"
            value = var.replicas
          },
          {
            name  = "ZEEBE_BROKER_CLUSTER_PARTITIONSCOUNT"
            value = var.replicas
          },
          {
            name  = "ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR"
            value = var.ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR
          },
          {
            name  = "ZEEBE_BROKER_CLUSTER_CLUSTERNAME"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "ZEEBE_GATEWAY_CLUSTER_CLUSTERNAME"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "ZEEBE_GATEWAY_CLUSTER_MEMBERID"
            value = "$(POD_NAME)"
          },
          {
            name  = "JAVA_TOOL_OPTIONS"
            value = "-Xms$(REQUESTS_MEMORY)m -Xmx$(LIMITS_MEMORY)m ${var.JAVA_TOOL_OPTIONS}"
          },
          {
            name  = "ZEEBE_LOG_LEVEL"
            value = var.ZEEBE_LOG_LEVEL
          },
        ], var.env)

        command = [
          "sh",
          "-cx",
          <<-EOF
          export ZEEBE_BROKER_CLUSTER_NODEID="$${HOSTNAME##*-}"
          exec /usr/local/zeebe/bin/broker
          EOF
        ]

        readiness_probe = {
          initial_delay_seconds = 10
          http_get = {
            path = "/ready"
            port = 9600
          }
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/usr/local/zeebe/data"
          },
        ]
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
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}