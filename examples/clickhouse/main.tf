module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

locals {
  cluster_name        = "cluster"
  clickhouse_replicas = 1
  clickhouse_keeper_replicas = 1
}


module "clickhouse_keeper_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "clickhouse-keeper-config"
  namespace = module.namespace.name

  from-map = {
    "keeper.yaml" = <<-EOF
      listen_host: 0.0.0.0
      keeper_server:
        tcp_port: 9181
        server_id: 1
        raft_configuration:
          server:
            id: 1
            hostname: clickhouse-keeper-0.clickhouse-keeper
            port: 9234
      logger:
        level: information
        console: 1
        log:
          "@remove": remove
        errorlog:
          "@remove": remove
      EOF
  }
}

module "clickhouse_keeper" {
  source    = "../../modules/generic-statefulset-service"
  name      = "clickhouse-keeper"
  namespace = module.namespace.name
  annotations = {
    checksum = module.clickhouse_keeper_config.checksum
  }
  image     = "clickhouse/clickhouse-keeper"
  ports_map = { tcp = 9181 }

  configmap            = module.clickhouse_keeper_config.config_map
  configmap_mount_path = "/etc/clickhouse-keeper/keeper_config.d"

  liveness_probe = {
    exec = {
      command = [
        "bash",
        "-cx",
        <<-EOF
        echo ruok | nc 0.0.0.0 9181
        EOF
      ]
    }
  }
}


module "clickhouse_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "clickhouse-config"
  namespace = module.namespace.name

  from-map = {
    "cluster.yaml" = <<-EOF
      http_port: 8123
      tcp_port: 9000
      mysql_port: 9004
      postgresql_port: 9005
      interserver_http_port: 9009
      listen_host: 0.0.0.0
      remote_servers:
        ${local.cluster_name}:
          shard:
            replica:
              host: ${var.name}-0.${var.name}
              port: 9000
      zookeeper:
        - node:
            host: ${module.clickhouse_keeper.name}-0.${module.clickhouse_keeper.name}
            port: ${module.clickhouse_keeper.ports[0].port}
      logger:
        level: warning
        console: 1
        log:
          "@remove": remove
        errorlog:
          "@remove": remove
      EOF
  }
}

module "clickhouse" {
  source    = "../../modules/generic-statefulset-service"
  name      = var.name
  namespace = module.namespace.name
  annotations = {
    checksum = module.clickhouse_config.checksum
  }
  image     = "clickhouse/clickhouse-server"
  ports_map = { http = 8123, tcp = 9000 }

  configmap            = module.clickhouse_config.config_map
  configmap_mount_path = "/etc/clickhouse-server/config.d"

  env_map = {
    CLICKHOUSE_USER     = "clickhouse"
    CLICKHOUSE_PASSWORD = "clickhouse"
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/ping"
      port = 8123
    }
  }

  storage    = "10Gi"
  mount_path = "/var/lib/clickhouse"
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.clickhouse.name
              port {
                number = module.clickhouse.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

