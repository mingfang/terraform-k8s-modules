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
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
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

module "cadence" {
  source    = "../../modules/cadence/server"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas

  CASSANDRA_SEEDS = module.cassandra.name
}

module "web" {
  source    = "../../modules/cadence/web"
  name      = "${var.name}-web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CADENCE_TCHANNEL_PEERS = "${module.cadence.name}:7933"
}

resource "k8s_extensions_v1beta1_ingress" "web" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
    }
    name      = module.web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.web.name
      http {
        paths {
          backend {
            service_name = module.web.name
            service_port = 8088
          }
          path = "/"
        }
      }
    }
  }
}
