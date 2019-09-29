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
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "runner"
        image = "${var.image}"

        command = [
          "sh",
          "-cex",
          <<-EOF
              mkdir -p /etc/gitlab-runner/
              cp /config/config.toml /etc/gitlab-runner/
              /entrypoint register \
                --non-interactive \
                --registration-token "${var.registration_token}" \
                --url "${var.gitlab_url}" \
                --executor "kubernetes" \
                --kubernetes-privileged "true"
              /entrypoint run
              EOF
          ,
        ]

        lifecycle = {
          pre_stop = {
            exec = {
              command = [
                "gitlab-runner",
                "unregister",
                "--all-runners",
              ]
            }
          }
        }

        volume_mounts = [
          {
            name = "config"
            mount_path = "/config"
          },
          {
            name = "docker"
            mount_path = "/var/run/docker.sock"
          },
          {
            name = "etc-gitlab-runner"
            mount_path = "/etc/gitlab-runner"
          },
        ]
      },
    ]
    volumes = [
      {
        name = "config"

        config_map = {
          name = "${k8s_core_v1_config_map.this.metadata.0.name}"
        }
      },
      {
        name = "docker"

        host_path = {
          path = "/var/run/docker.sock"
        }
      },
      {
        name = "etc-gitlab-runner"

        empty_dir = {
          medium = "Memory"
        }
      },
    ]
    service_account_name = k8s_core_v1_service_account.this.metadata.0.name
  }
}


module "deployment-service" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
