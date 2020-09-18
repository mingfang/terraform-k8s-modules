locals {
  discovery-members = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:5000"
    ]
  )

  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "neo4j"
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
            name = "NEO4J_ACCEPT_LICENSE_AGREEMENT"
            value = var.NEO4J_ACCEPT_LICENSE_AGREEMENT
          },
          {
            name = "NEO4J_dbms_mode"
            value = "CORE"
          },
          {
            name = "NEO4J_causal__clustering_minimum__core__cluster__size__at__formation"
            value = var.replicas
          },
          {
            name = "NEO4J_causal__clustering_discovery__type"
            value = "LIST"
          },
          {
            name = "NEO4J_causal__clustering_initial__discovery__members"
            value = local.discovery-members
          },
        ], var.env)

        command = [
          "bash",
          "-cx",
          <<-EOF
          export NEO4J_dbms_default__advertised__address=$(hostname -f)
          export NEO4J_causal__clustering_discovery__advertised__address=$(hostname -f):5000
          export NEO4J_causal__clustering_transaction__advertised__address=$(hostname -f):6000
          export NEO4J_causal__clustering_raft__advertised__address=$(hostname -f):7000
          if [ "$${AUTH_ENABLED:-}" == "true" ]; then
            export NEO4J_AUTH="neo4j/$${NEO4J_SECRETS_PASSWORD}"
          else
            export NEO4J_AUTH="none"
          fi
          exec /docker-entrypoint.sh "neo4j"
          EOF
        ]

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          }
        ]
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
          chown neo4j /data
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