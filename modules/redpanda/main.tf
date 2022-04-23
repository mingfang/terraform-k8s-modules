locals {
  mount_path = "/var/lib/redpanda/data"
}

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "redpanda"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          REDPANDA_NODEID="$(expr $${HOSTNAME//[^0-9]/})"
          REDPANDA_ADVERTISE_ADDR="$${HOSTNAME}.${var.name}"
          # seed list only for node-id > 0
          if [ "$${REDPANDA_NODEID}" -gt 0 ]; then
            REDPANDA_SEEDS_ARG="--seeds ${var.name}-0.${var.name}:33145"
          fi

          rpk redpanda start \
          --smp 1  \
          --memory 1G  \
          --reserve-memory 0M \
          --overprovisioned \
          --node-id "$${REDPANDA_NODEID}" \
          $${REDPANDA_SEEDS_ARG} \
          --check=false \
          --pandaproxy-addr 0.0.0.0:8082 \
          --advertise-pandaproxy-addr $${REDPANDA_ADVERTISE_ADDR}:8082 \
          --kafka-addr 0.0.0.0:9092 \
          --advertise-kafka-addr $${REDPANDA_ADVERTISE_ADDR}:9092 \
          --rpc-addr 0.0.0.0:33145 \
          --advertise-rpc-addr $${REDPANDA_ADVERTISE_ADDR}:33145
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = local.mount_path
          },
        ]
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
          chown redpanda ${local.mount_path}
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = local.mount_path
          },
        ]
      },
    ]

    node_selector = var.node_selector

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