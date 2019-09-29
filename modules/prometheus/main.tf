/**
 * Documentation
 *
 * [Kubernetes Discovery](https://raw.githubusercontent.com/prometheus/prometheus/release-2.5/documentation/examples/prometheus-kubernetes.yml)
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
        name  = "prometheus"
        image = var.image
        env   = var.env

        args = [
          "--config.file=/config/prometheus.yml",
        ]

        liveness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 60
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/-/healthy"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 5
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/-/ready"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        volume_mounts = [
          {
            mount_path = "/config"
            name       = "config"
          },
          {
            name       = var.volume_claim_template_name
            mount_path = "/prometheus-data"
            sub_path   = var.name
          },
        ]
      },
    ]
    volumes = [
      {
        name = "config"

        config_map = {
          name = k8s_core_v1_config_map.this.metadata.0.name
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
    service_account_name = module.rbac.service_account.metadata.0.name
  }
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

module "rbac" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "nodes",
        "nodes/proxy",
        "services",
        "endpoints",
        "pods",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]

      resources = [
        "ingresses",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      non_resource_urls = [
        "/metrics",
      ]

      verbs = [
        "get",
      ]
    },
  ]
}
