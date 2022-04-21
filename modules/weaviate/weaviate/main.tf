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
        name  = "weaviate"
        image = var.image
        args = [
          "--host",
          "0.0.0.0",
          "--port",
          var.ports[0].port,
          "--scheme",
          "http",
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
            name = "POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "CONTEXTIONARY_URL"
            value = var.CONTEXTIONARY_URL
          },
          {
            name  = "TRANSFORMERS_INFERENCE_API"
            value = var.TRANSFORMERS_INFERENCE_API
          },
          {
            name  = "QNA_INFERENCE_API"
            value = var.QNA_INFERENCE_API
          },
          {
            name  = "NER_INFERENCE_API"
            value = var.NER_INFERENCE_API
          },
          {
            name  = "SPELLCHECK_INFERENCE_API"
            value = var.SPELLCHECK_INFERENCE_API
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
            name  = "PERSISTENCE_DATA_PATH"
            value = var.PERSISTENCE_DATA_PATH
          },
          {
            name  = "DEFAULT_VECTORIZER_MODULE"
            value = var.DEFAULT_VECTORIZER_MODULE
          },
          {
            name  = "ENABLE_MODULES"
            value = var.ENABLE_MODULES
          },
          {
            name  = "CLUSTER_HOSTNAME"
            value = "$(POD_NAME)"
          },
        ], var.env)

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
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}