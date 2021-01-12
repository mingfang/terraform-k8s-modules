locals {
  cluster-name = "${var.name}-${var.namespace}"
  servers = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local"
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
        name  = "cockroachdb"
        image = var.image

        env = concat([
          {
            name  = "COCKROACH_CHANNEL"
            value = "kubernetes-insecure"
          },
          {
            name = "GOMAXPROCS"
            value_from = {
              resource_field_ref = {
                resource = "limits.cpu"
                divisor  = "1"
              }
            }
          },
          {
            name = "MEMORY_LIMIT_MIB"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
        ], var.env)

        command = [
          "/bin/bash",
          "-cx",
          <<-EOF
          /cockroach/cockroach start \
            --logtostderr \
            --insecure \
            --advertise-host $(hostname -f) \
            --http-addr 0.0.0.0 \
            --cluster-name ${local.cluster-name} \
            --join ${local.servers} \
            --cache $(expr $MEMORY_LIMIT_MIB / 4)MiB \
            --max-sql-memory $(expr $MEMORY_LIMIT_MIB / 4)MiB \
          EOF
        ]

        liveness_probe = {
          http_get = {
            path = "/health"
            port = var.ports[1].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }
        readiness_probe = {
          http_get = {
            path = "/health?ready=1"
            port = var.ports[1].port
          }
          initial_delay_seconds = 10
          period_seconds        = 5
          failure_threshold     = 2
        }

        resources                        = var.resources
        termination_grace_period_seconds = 60

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/cockroach/cockroach-data"
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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}