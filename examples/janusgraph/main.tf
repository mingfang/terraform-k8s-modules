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

module "scylla-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "scylla"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = var.replicas
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "scylla" {
  source    = "../../modules/scylla"
  name      = "scylla"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.scylla-storage.replicas
  storage       = module.scylla-storage.storage
  storage_class = module.scylla-storage.storage_class_name
}

module "elasticsearch_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.elasticsearch_storage.replicas
  storage       = module.elasticsearch_storage.storage
  storage_class = module.elasticsearch_storage.storage_class_name
}


module "janusgraph" {
  source    = "../../modules/janusgraph"
  name      = "janusgraph"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env = [
    {
      name  = "JANUS_PROPS_TEMPLATE"
      value = "cql-es"
    },
    {
      name  = "janusgraph.storage.hostname"
      value = module.scylla.service.metadata[0].name
    },
    {
      name  = "janusgraph.index.search.hostname"
      value = module.elasticsearch.service.metadata[0].name
    },
    {
      name  = "gremlinserver.channelizer"
      value = "org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer"
    },
  ]
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "janusgraph.*"
    }
    name      = "janusgraph"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "janusgraph"
      http {
        paths {
          backend {
            service_name = module.janusgraph.name
            service_port = module.janusgraph.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
