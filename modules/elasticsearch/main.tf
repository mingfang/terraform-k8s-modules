locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  seed_hosts = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local"
    ]
  )
}

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "elasticsearch"
        image = var.image

        command = [
          "bash",
          "-c",
          <<-EOF
          mkdir -p ${var.mount_path}
          chown elasticsearch ${var.mount_path}
          su elasticsearch
          /usr/local/bin/docker-entrypoint.sh eswrapper
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
            name       = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name       = "LIMITS_MEMORY"
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
            value = local.seed_hosts
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
            value = "false"
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
        ] : [], var.env, local.computed_env)

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
          var.storage != null ? [
            {
              name       = var.volume_claim_template_name
              mount_path = var.mount_path
            },
          ] : [],
          var.configmap != null ? [
            for k, v in var.configmap.data :
            {
              name       = "config"
              mount_path = "${var.configmap_mount_path}/${k}"
              sub_path   = k
            }
          ] : [],
          var.secret != null ? [
            for k, v in var.secret.data :
            {
              name       = "secret"
              mount_path = "/usr/share/elasticsearch/config/${k}"
              sub_path   = k
            }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          sysctl -w vm.max_map_count=262144
          ulimit -l unlimited
          mkdir -p ${var.mount_path}/$POD_NAME
          chown -R elasticsearch ${var.mount_path}
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
        ])

        security_context = {
          privileged = true
          run_asuser = "0"
        }

        volume_mounts = var.storage != null ? [
          {
            name       = var.volume_claim_template_name
            mount_path = var.mount_path
          },
        ] : []
      },
    ]

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

    image_pull_secrets   = var.image_pull_secrets
    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = concat(
      var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
      var.secret != null ? [
        {
          name = "secret"

          secret = {
            secret_name = var.secret.metadata[0].name
          }
        }
      ] : [],
      [], //hack: without this, sub_path above stops working
    )

    volume_claim_templates = var.storage != null ? [
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
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
