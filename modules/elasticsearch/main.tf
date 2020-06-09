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
        name  = "elasticsearch"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          sysctl -w vm.max_map_count=262144
          ulimit -l unlimited
          su elasticsearch
          if [[ "$POD_NAME" == "${var.name}-0" ]]; then
            env node.master=true node.data=false node.ingest=false /usr/local/bin/docker-entrypoint.sh
          else
            env node.master=false node.data=true node.ingest=true /usr/local/bin/docker-entrypoint.sh
          fi
          EOF
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
            name  = "node.name"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "cluster.name"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "discovery.seed_hosts"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "cluster.initial_master_nodes"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "bootstrap.memory_lock"
            value = "true"
          },
          {
            name  = "ES_JAVA_OPTS"
            value = "-Xms${var.heap_size} -Xmx${var.heap_size}"
          },
          {
            name  = "path.data"
            value = "/data/$(POD_NAME)"
          },
        ], var.env)

        liveness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 120
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 30
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        resources = var.resources

        security_context = {
          capabilities = {
            add = [
              "IPC_LOCK",
            ]
          }
          privileged = true
        }

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
          chown elasticsearch /data
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
