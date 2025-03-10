locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      { "checksum" = md5(join("", keys(local.config_map), values(local.config_map))) },
    )

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "dataflow-server"
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "SPRING_CLOUD_CONFIG_ENABLED"
            value = "false"
          },
          {
            name  = "SPRING_CLOUD_KUBERNETES_CONFIG_ENABLE_API"
            value = "false"
          },
          {
            name  = "SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API"
            value = "false"
          },
          {
            name  = "SPRING_CLOUD_KUBERNETES_SECRETS_PATHS"
            value = "/etc/secrets"
          },
          {
            name  = "SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED"
            value = "true"
          },
          {
            name  = "SPRING_CLOUD_DATAFLOW_FEATURES_TASKS_ENABLED"
            value = "true"
          },
          {
            name  = "SPRING_CLOUD_DATAFLOW_FEATURES_SCHEDULES_ENABLED"
            value = "true"
          },
          {
            name  = "SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI"
            value = var.SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI
          },
          {
            name  = "SPRING_APPLICATION_JSON"
            value = "{ \"maven\": { \"local-repository\": null, \"remote-repositories\": { \"repo1\": { \"url\": \"https://repo.spring.io/libs-snapshot\"} } } }"
          },
          {
            name = "KUBERNETES_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name  = "KUBERNETES_TRUST_CERTIFICATES"
            value = "false"
          },
          {
            name  = "SPRING_CLOUD_DATAFLOW_TASK_COMPOSEDTASKRUNNER_URI"
            value = "docker://docker.io/bitnami/spring-cloud-dataflow-composed-task-runner:2.7.0-debian-10-r3"
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/application.yaml"
            sub_path   = "application.yaml"
            read_only  = true
          }
        ]
      },
    ]

    service_account_name = module.rbac.name

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}