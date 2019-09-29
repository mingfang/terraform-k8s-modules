/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
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
        name  = "gitlab"
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
            name  = "GITLAB_ROOT_PASSWORD"
            value = var.gitlab_root_password
          },
          {
            name  = "GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN"
            value = var.gitlab_runners_registration_token
          },
          {
            name  = "AUTO_DEVOPS_DOMAIN"
            value = var.auto_devops_domain
          },
          {
            name  = "GITLAB_OMNIBUS_CONFIG"
            value = local.gitlab_omnibus_config
          },
        ], var.env)

        liveness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 600
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/help"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold = 3
          period_seconds    = 10
          success_threshold = 1
          timeout_seconds   = 1

          http_get = {
            path   = "/help"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        volume_mounts = [
          {
            mount_path = "/var/opt/gitlab"
            name       = var.volume_claim_template_name
            sub_path   = "gitlab/var/opt/gitlab"
          },
          {
            mount_path = "/etc/gitlab"
            name       = var.volume_claim_template_name
            sub_path   = "gitlab/etc/gitlab"
          },
        ]
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

  gitlab_omnibus_config = <<-EOF
    external_url '${var.gitlab_external_url}';
    gitlab_rails['lfs_enabled'] = true;
    nginx['listen_port'] = 80;
    nginx['listen_https'] = false;
    mattermost_external_url '${var.mattermost_external_url}';
    mattermost_nginx['listen_port'] = 80;
    mattermost_nginx['listen_https'] = false;
    registry_external_url '${var.registry_external_url}';
    registry_nginx['listen_port'] = 80;
    registry_nginx['listen_https'] = false;
    EOF
}


module "statefulset-service" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

module "rbac" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/rbac"
  name = var.name
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