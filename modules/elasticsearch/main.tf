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
        name  = "elasticsearch"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          sysctl -w vm.max_map_count=262144
          ulimit -l unlimited
          su elasticsearch
          /usr/local/bin/docker-entrypoint.sh eswrapper
          EOF
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
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
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
            name  = "node.name"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "cluster.name"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "discovery.seed_hosts"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "cluster.initial_master_nodes"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "bootstrap.memory_lock"
            value = "true"
          },
          {
            name  = "ES_JAVA_OPTS"
            value = "-Xms$(REQUESTS_MEMORY)m -Xmx$(REQUESTS_MEMORY)m ${var.ES_JAVA_OPTS}"
          },
          {
            name  = "path.data"
            value = "/data/$(POD_NAME)"
          },
          ], var.secret != null ? [
          {
            name  = "xpack.security.enabled"
            value = "true"
          },
          {
            name  = "xpack.security.authc.realms.native.native1.order"
            value = "0"
          },
          {
            name  = "xpack.security.transport.ssl.enabled"
            value = "true"
          },
          {
            name  = "xpack.security.transport.ssl.verification_mode"
            value = "certificate"
          },
          {
            name  = "xpack.security.transport.ssl.client_authentication"
            value = "required"
          },
          {
            name  = "xpack.security.transport.ssl.certificate_authorities"
            value = "/usr/share/elasticsearch/config/ca.crt"
          },
          {
            name  = "xpack.security.transport.ssl.certificate"
            value = "/usr/share/elasticsearch/config/tls.crt"
          },
          {
            name  = "xpack.security.transport.ssl.key"
            value = "/usr/share/elasticsearch/config/tls.key"
          },
        ] : [], var.env)

        liveness_probe = {
          tcp_socket = {
            port = 9300
          }
          initial_delay_seconds = 120
          timeout_seconds       = 10
        }

        readiness_probe = {
          tcp_socket = {
            port = 9200
          }
          initial_delay_seconds = 30
          timeout_seconds       = 10
        }

        resources = var.resources

        security_context = {
          capabilities = {
            add = [
              "IPC_LOCK",
            ]
          }
          privileged = true
        }

        volume_mounts = concat(
          [
            {
              name       = var.volume_claim_template_name
              mount_path = "/data"
            },
          ],
          var.secret != null ? [
            for k, v in var.secret.data :
            {
              name       = "secret"
              mount_path = "/usr/share/elasticsearch/config/${k}"
              sub_path   = k
            }
          ] : [],
        )
      },
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          chown elasticsearch /data
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          },
        ]
      },
    ]

    node_selector = var.node_selector

    volumes = var.secret != null ? [
      {
        name = "secret"

        secret = {
          secret_name = var.secret.metadata[0].name
        }
      }
    ] : []

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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
