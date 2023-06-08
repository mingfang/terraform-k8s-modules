locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name    = "weaviate"
        image   = var.image
        command = [
          "sh",
          "-c",
          <<-EOF
          ulimit -n 65535
          exec /bin/weaviate \
            --host 0.0.0.0 \
            --port ${var.ports[0].port} \
            --scheme http \
            --read-timeout=600s \
            --write-timeout=600s
          EOF
        ]

        env = concat([
          {
            name       = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "CLUSTER_HOSTNAME"
            value = "$(POD_NAME)"
          },
          {
            name  = "ENABLE_MODULES"
            value = var.ENABLE_MODULES
          },
          {
            name  = "PERSISTENCE_DATA_PATH"
            value = var.PERSISTENCE_DATA_PATH
          },
          {
            name  = "DEFAULT_VECTORIZER_MODULE"
            value = var.DEFAULT_VECTORIZER_MODULE
          },
          {
            name  = "QUERY_DEFAULTS_LIMIT"
            value = var.QUERY_DEFAULTS_LIMIT
          },
          {
            name  = "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED"
            value = var.AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED
          },
          {
            name  = "CLUSTER_GOSSIP_BIND_PORT"
            value = "7000"
          },
          {
            name  = "CLUSTER_DATA_BIND_PORT"
            value = "7001"
          },
          {
            name  = "CLUSTER_JOIN"
            value = "${var.name}-srv.${var.namespace}.svc.cluster.local"
            #            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "LOG_LEVEL"
            value = var.LOG_LEVEL
          }
        ], var.env, local.computed_env)

        liveness_probe = {
          http_get = {
            path = "/v1/.well-known/live"
            port = 8080
          }
          initial_delay_seconds = 120
          period_seconds        = 3
        }

        readiness_probe = {
          http_get = {
            path = "/v1/.well-known/ready"
            port = 8080
          }
          initial_delay_seconds = 3
          period_seconds        = 3
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = var.PERSISTENCE_DATA_PATH
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
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}