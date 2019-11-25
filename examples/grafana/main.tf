resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "cassandra-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "cassandra"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.cassandra-storage.replicas
  storage       = module.cassandra-storage.storage
  storage_class = module.cassandra-storage.storage_class_name
}

module "loki" {
  source    = "../../modules/grafana/loki"
  name      = "loki"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  cassandra = module.cassandra.name
}

module "promtail" {
  source    = "../../modules/grafana/promtail"
  name      = "promtail"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  loki_url  = "http://${module.loki.name}:3100/loki/api/v1/push"
}

module "grafana" {
  source           = "../../modules/grafana/grafana"
  name             = "grafana"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  datasources_file = "${path.module}/datasources.yaml"
}

resource "k8s_extensions_v1beta1_ingress" "grafana" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "grafana.*"
    }
    name      = module.grafana.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.grafana.name
      http {
        paths {
          backend {
            service_name = module.grafana.name
            service_port = 3000
          }
          path = "/"
        }
      }
    }
  }
}
