resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "${var.name}-nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "elasticsearch_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = module.elasticsearch_storage.replicas

  storage_class = module.elasticsearch_storage.storage_class_name
  storage       = module.elasticsearch_storage.storage

  heap_size = "4g"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "elasticsearch" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.${var.namespace}.*"
    }
    name      = module.elasticsearch.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.elasticsearch.name
      http {
        paths {
          backend {
            service_name = module.elasticsearch.name
            service_port = 9200
          }
          path = "/"
        }
      }
    }
  }
}