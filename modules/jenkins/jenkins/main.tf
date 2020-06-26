locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = 1
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "jenkins"
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
            name = "LIMITS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name  = "JAVA_OPTS"
            value = <<-EOF
            -Xmx$(LIMITS_MEMORY)m
            -XshowSettings:vm
            -Dhudson.slaves.NodeProvisioner.initialDelay=0
            -Dhudson.slaves.NodeProvisioner.MARGIN=50
            -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85
            -Dhudson.model.DirectoryBrowserSupport.CSP="default-src 'self' 'unsafe-inline'; img-src 'self' 'unsafe-inline' data:; style-src 'self' 'unsafe-inline'; child-src 'self' 'unsafe-inline'; frame-src 'self' 'unsafe-inline'; font-src 'self' data:;"
            -Djenkins.install.runSetupWizard=false
            EOF
          }
        ], var.env)

        resources = var.resources

        liveness_probe = {
          initial_delay_seconds = 60
          failure_threshold     = 12

          http_get = {
            path = "/login"
            port = 8080
          }
        }

        readiness_probe = {
          initial_delay_seconds = 60
          failure_threshold     = 12

          http_get = {
            path = "/login"
            port = 8080
          }
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/jenkins_home"
          },
          {
            name       = "casc-configs"
            mount_path = "/var/jenkins_home/casc_configs"
          },
        ]
      }
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          "chown jenkins /var/jenkins_home"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/jenkins_home"
          },
        ]
      }
    ]

    security_context = {
      fsgroup : 1000
    }

    service_account_name = module.rbac.service_account.metadata[0].name

    strategy = {
      type = "Recreate"
    }

    volumes = [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      },
      {
        name = "casc-configs"
        config_map = {
          name = var.casc_config_map_name
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
