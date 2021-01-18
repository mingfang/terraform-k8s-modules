locals {
  suffix = "${var.name}.${var.namespace}.svc.cluster.local"
  config_map = {
    "enabled_plugins" = "[rabbitmq_management,rabbitmq_prometheus,rabbitmq_stomp,rabbitmq_web_stomp]."
    "rabbitmq.conf"   = <<-EOF
      loopback_users.guest = false
      listeners.tcp.default = ${var.ports[0].port}
      management.tcp.port = ${var.ports[1].port}

      #clustering
      cluster_name = ${var.name}.${var.namespace}
      cluster_formation.peer_discovery_backend = classic_config

      %{for i in range(0, var.replicas)}
      cluster_formation.classic_config.nodes.${i + 1} = rabbit@${var.name}-${i}.${local.suffix}
      %{endfor}

      #stomp
      stomp.proxy_protocol = true
      web_stomp.proxy_protocol = false
      EOF
  }

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
        name  = "rabbitmq"
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
            name  = "RABBITMQ_NODENAME"
            value = "rabbit@$(POD_NAME).${local.suffix}"
          },
          {
            name  = "RABBITMQ_USE_LONGNAME"
            value = "true"
          },
          {
            name  = "RABBITMQ_ERLANG_COOKIE"
            value = var.RABBITMQ_ERLANG_COOKIE
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/var/lib/rabbitmq"
          },
          {
            name       = "config"
            mount_path = "/etc/rabbitmq"
          }
        ]
      },
    ]

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      }
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

module "config" {
  source    = "../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-map  = local.config_map
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}