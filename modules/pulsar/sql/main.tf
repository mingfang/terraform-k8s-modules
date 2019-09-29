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

    containers = [
      {
        name  = "pulsar"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          if [ "$discovery_uri" ]; then
            # Worker
            sed -i -e "s|discovery-server.enabled=.*|discovery-server.enabled=false|" conf/presto/config.properties
            sed -i -e "s|discovery.uri=.*|discovery.uri=${var.discovery_uri}|" conf/presto/config.properties
            sed -i -e "s|scheduler.http-client..*||" conf/presto/config.properties
            echo "coordinator=false" >> conf/presto/config.properties
          else
            # Coordinator
            sed -i -e "s|node-scheduler.include-coordinator=.*|node-scheduler.include-coordinator=false|" conf/presto/config.properties
            sed -i -e "s|scheduler.http-client..*||" conf/presto/config.properties
            echo "coordinator=true" >> conf/presto/config.properties
          fi
          sed -i -e "s|node.id=.*|node.id=$(cat /proc/sys/kernel/random/uuid)|" conf/presto/config.properties
          sed -i -e "s|pulsar.broker-service-url=.*|pulsar.broker-service-url=${var.pulsar}|" conf/presto/catalog/pulsar.properties
          sed -i -e "s|pulsar.zookeeper-uri=.*|pulsar.zookeeper-uri=${var.zookeeper}|" conf/presto/catalog/pulsar.properties
          bin/pulsar sql-worker run
          EOF
        ]
        env = [
          {
            name  = "discovery_uri"
            value = var.discovery_uri
          },
          {
            name  = "pulsar"
            value = var.pulsar
          },
          {
            name  = "zookeeper"
            value = var.zookeeper
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
