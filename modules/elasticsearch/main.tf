/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "elasticsearch"
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
            name  = "cluster.name"
            value = var.name
          },
          {
            name  = "node.name"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "discovery.zen.ping.unicast.hosts"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
//          {
//            name  = "discovery.seed_hosts"
//            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
//          },
//          {
//            name  = "cluster.initial_master_nodes"
//            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
//          },
          {
            name  = "bootstrap.memory_lock"
            value = "false"
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

        resources = {
          requests = {
            cpu    = "250m"
            memory = "4Gi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          },
        ]
      },
    ]

    init_containers = [
      {
        name              = "init"
        image             = "busybox"
        image_pull_policy = "IfNotPresent"

        command = [
          "sh",
          "-cx",
          <<-EOF
          sysctl -w vm.max_map_count=262144
          ulimit -l unlimited
          EOF
        ]

        security_context = {
          privileged = true
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
