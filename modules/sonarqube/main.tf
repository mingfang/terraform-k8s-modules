

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
        name  = "wordpress"
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
            name  = "SONAR_JDBC_URL"
            value = var.SONAR_JDBC_URL
          },
          {
            name  = "SONAR_JDBC_USERNAME"
            value = var.SONAR_JDBC_USERNAME
          },
          {
            name  = "SONAR_JDBC_PASSWORD"
            value = var.SONAR_JDBC_PASSWORD
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "sonarqube-data"
            mount_path = "/opt/sonarqube/data"
          },
          {
            name       = "sonarqube-extensions"
            mount_path = "/opt/sonarqube/extensions"
          },
          {
            name       = "sonarqube-logs"
            mount_path = "/opt/sonarqube/logs"
          },
        ]
      }
    ]

    init_containers = [
      {
        name  = "init"
        image = "busybox:1.31"

        command = [
          "sh",
          "-cx",
          <<-EOF
          chown 999:999 /opt/sonarqube/data
          chown 999:999 /opt/sonarqube/extensions
          chown 999:999 /opt/sonarqube/logs
          sysctl -w vm.max_map_count=262144
          EOF
        ]

        security_context = {
          privileged = true
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "sonarqube-data"
            mount_path = "/opt/sonarqube/data"
          },
          {
            name       = "sonarqube-extensions"
            mount_path = "/opt/sonarqube/extensions"
          },
          {
            name       = "sonarqube-logs"
            mount_path = "/opt/sonarqube/logs"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "sonarqube-data"
        persistent_volume_claim = {
          claim_name = var.sonarqube_data_pvc_name
        },
      },
      {
        name = "sonarqube-extensions"
        persistent_volume_claim = {
          claim_name = var.sonarqube_extensions_pvc_name
        },
      },
      {
        name = "sonarqube-logs"
        persistent_volume_claim = {
          claim_name = var.sonarqube_logs_pvc_name
        },
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
