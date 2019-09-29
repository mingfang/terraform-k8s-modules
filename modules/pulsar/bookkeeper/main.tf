/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
    replicas  = var.replicas
    ports     = var.ports

    enable_service_links        = false
    publish_not_ready_addresses = true

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "8000"
    }

    containers = [
      {
        name  = "bookie"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          bin/apply-config-from-env.py conf/bookkeeper.conf
          bin/apply-config-from-env.py conf/pulsar_env.sh
          bin/bookkeeper shell metaformat --nonInteractive --force || true
          bin/pulsar bookie
          EOF
        ]
        env = [
          {
            name  = "zkServers"
            value = var.zookeeper
          },
          {
            name  = "statsProviderClass"
            value = "org.apache.bookkeeper.stats.prometheus.PrometheusMetricsProvider"
          },
          {
            name  = "clusterName"
            value = var.clusterName
          },
          {
            name  = "dbStorage_writeCacheMaxSizeMb"
            value = var.dbStorage_writeCacheMaxSizeMb
          },
          {
            name  = "dbStorage_readAheadCacheMaxSizeMb"
            value = var.dbStorage_readAheadCacheMaxSizeMb
          },
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name  = "advertisedAddress"
            value = "$(POD_NAME).${var.name}.$(POD_NAMESPACE)"
          },
          {
            name  = "PULSAR_MEM"
            value = "\" ${var.PULSAR_MEM}\""
          },
          {
            name  = "BOOKIE_EXTRA_OPTS"
            value = var.EXTRA_OPTS
          },
        ]

        liveness_probe = {
          initial_delay_seconds = 120
          period_seconds        = 60

          exec = {
            command = [
              "sh",
              "-cx",
              "bin/bookkeeper shell bookiesanity",
            ]
          }
        }

        readiness_probe = {
          initial_delay_seconds = 10

          exec = {
            command = [
              "sh",
              "-cx",
              "bin/bookkeeper shell bookiesanity",
            ]
          }
        }
      },
    ]
  }
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
