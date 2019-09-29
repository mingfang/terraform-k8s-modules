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

    enable_service_links = false

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "8080"
    }

    containers = [
      {
        name  = "pulsar"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          bin/apply-config-from-env.py conf/websocket.conf
          bin/apply-config-from-env.py conf/pulsar_env.sh
          bin/pulsar websocket
          EOF
        ]
        env = [
          {
            name  = "configurationStoreServers"
            value = var.configurationStoreServers
          },
          {
            name  = "clusterName"
            value = var.clusterName
          },
          {
            name  = "PULSAR_MEM"
            value = "\" ${var.PULSAR_MEM}\""
          },
          {
            name  = "PULSAR_EXTRA_OPTS"
            value = var.EXTRA_OPTS
          },
        ]
      },
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
