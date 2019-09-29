/**
 * [Elasticsearch](https://www.elastic.co/products/elasticsearch)
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "elasticsearch"
        image = "${var.image}"

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
            value = "${var.name}"
          },
          {
            name  = "node.name"
            value = "$(POD_NAME)"
          },
          {
            name  = "discovery.zen.ping.unicast.hosts"
            value = "${var.name}"
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
            port   = "${var.ports.0.port}"
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
            port   = "${var.ports.0.port}"
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
            name       = "${var.volume_claim_template_name}"
            mount_path = "/data"
            sub_path   = "${var.name}"
          },
        ]
      },
    ]
    init_containers = [
      {
        name              = "fix-the-volume-permission"
        image             = "busybox"
        image_pull_policy = "IfNotPresent"


        command = [
          "sh",
          "-c",
          "mkdir -p /data/$(POD_NAME) && chown -R 1000:1000 /data/$(POD_NAME)",
        ]

        security_context = {
          privileged = true
        }

        volume_mounts = [
          {
            name       = "${var.volume_claim_template_name}"
            mount_path = "/data"
            sub_path   = "${var.name}"
          },
        ]
      },
      {
        name              = "increase-the-vm-max-map-count"
        image             = "busybox"
        image_pull_policy = "IfNotPresent"

        command = [
          "sysctl",
          "-w",
          "vm.max_map_count=262144",
        ]

        security_context = {
          privileged = true
        }
      },
      {
        name              = "increase-the-ulimit"
        image             = "busybox"
        image_pull_policy = "IfNotPresent"

        command = [
          "sh",
          "-c",
          "ulimit -n 65536",
        ]

        security_context = {
          privileged = true
        }
      },
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
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
