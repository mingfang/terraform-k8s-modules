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
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = "opa"
        image = var.image

        args = [
          "run",
          "--server",
          "--tls-ca-cert-file=/certs/ca.crt",
          "--tls-cert-file=/certs/tls.crt",
          "--tls-private-key-file=/certs/tls.key",
          "--addr=0.0.0.0:443",
          "--addr=http://127.0.0.1:8181",
          "--log-format=text",
          "--set=decision_logs.console=true",
          "--log-level=${var.log-level}",
          "--ignore=.*",
          "/policies",
          "--set=default_decision=library.kubernetes.admission.mutating.main",
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
        ], var.env)

        /* todo: failing with 400 code
        liveness_probe = {
          http_get = {
            schema = "HTTPS"
            port: 443
          }
        }

        readiness_probe = {
          http_get = {
            schema = "HTTPS"
            port: 443
            path = "/health?plugins&bundle"
          }
        }
        */

        volume_mounts = [
          {
            name       = "policies"
            mount_path = "/policies"
          },
          {
            name       = "webhook-certs"
            mount_path = "/certs"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "policies"
        config_map = {
          name = var.policies_config_map
        }
      },
      {
        name = "webhook-certs"
        secret = {
          secret_name = var.secret_name
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
