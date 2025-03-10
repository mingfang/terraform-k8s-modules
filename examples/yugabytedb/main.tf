resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "yb-nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "master-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "yb-master"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "master" {
  source    = "../../modules/yugabytedb/master"
  name      = "yb-master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.master-storage.replicas
  storage       = module.master-storage.storage
  storage_class = module.master-storage.storage_class_name
}

resource "k8s_extensions_v1beta1_ingress" "master" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "yugabytedb.*"
    }
    name      = module.master.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.master.name
      http {
        paths {
          backend {
            service_name = module.master.name
            service_port = module.master.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "tserver-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "yb-tserver"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "tserver" {
  source    = "../../modules/yugabytedb/tserver"
  name      = "yb-tserver"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.master-storage.replicas
  storage       = module.master-storage.storage
  storage_class = module.master-storage.storage_class_name

  tserver_master_addrs = module.master.master_addrs
}

module "janusgraph" {
  source    = "../../modules/janusgraph"
  name      = "yb-janusgraph"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env = [
    {
      name  = "janusgraph.gremlin.graph"
      value = "org.janusgraph.core.JanusGraphFactory"
    },
    {
      name  = "janusgraph.storage.backend"
      value = "cql"
    },
    {
      name  = "janusgraph.storage.cql.keyspace"
      value = "janusgraph"
    },
    {
      name  = "janusgraph.index.search.backend"
      value = "lucene"
    },
    {
      name  = "janusgraph.index.search.directory"
      value = "db/searchindex"
    },
    {
      name  = "janusgraph.storage.hostname"
      value = module.tserver.service.metadata[0].name
    },
    {
      name  = "gremlinserver.channelizer"
      value = "org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer"
    },
  ]
}

resource "k8s_extensions_v1beta1_ingress" "janusgraph" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "yb-janusgraph.*"
    }
    name      = module.janusgraph.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.janusgraph.name
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