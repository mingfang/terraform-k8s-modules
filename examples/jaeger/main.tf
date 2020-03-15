resource "k8s_core_v1_namespace" "this" {
  metadata {
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

  CASSANDRA_CLUSTER_NAME = "jaeger"
}

module "job" {
  source    = "../../modules/jaeger/cassandra-schema-job"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "config" {
  source    = "../../modules/jaeger/cassandra_config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "collector" {
  source          = "../../modules/jaeger/collector"
  name            = "jaeger-collector"
  namespace       = k8s_core_v1_namespace.this.metadata[0].name
  config_map_name = module.config.name
}

module "query" {
  source          = "../../modules/jaeger/query"
  name            = "jaeger-query"
  namespace       = k8s_core_v1_namespace.this.metadata[0].name
  config_map_name = module.config.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "jaeger" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "jaeger.${var.namespace}.*"
    }
    name      = "jaeger.${var.namespace}"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "jaeger.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.query.name
            service_port = module.query.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
