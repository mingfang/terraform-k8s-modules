resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "bookkeeper" {
  source        = "../../modules/pulsar/bookkeeper"
  name          = "bookkeeper"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  zookeeper = "${module.zookeeper.name}:2181"
}

module "pulsar" {
  source                    = "../../modules/pulsar/broker"
  name                      = "pulsar"
  namespace                 = k8s_core_v1_namespace.this.metadata[0].name
  replicas                  = 1
  storage                   = "1Gi"
  storage_class             = "cephfs"
  zookeeper                 = "${module.zookeeper.name}:2181"
  configurationStoreServers = "${module.zookeeper.name}:2181"
}

module "pulsar-sql-coordinator" {
  source    = "../../modules/pulsar/sql"
  name      = "pulsar-sql-coordinator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  pulsar    = "http://${module.pulsar.name}:8080"
  zookeeper = "${module.zookeeper.name}:2181"
}

resource "k8s_extensions_v1beta1_ingress" "pulsar-sql-coordinator" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "pulsar-sql.*",
    }
    name      = module.pulsar-sql-coordinator.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "pulsar-sql"
      http {
        paths {
          backend {
            service_name = module.pulsar-sql-coordinator.name
            service_port = "8081"
          }
          path = "/"
        }
      }
    }
  }
}

module "pulsar-sql-worker" {
  source    = "../../modules/pulsar/sql"
  name      = "pulsar-sql-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  discovery_uri = "http://${module.pulsar-sql-coordinator.name}:8081"
  pulsar        = "http://${module.pulsar.name}:8080"
  zookeeper     = "${module.zookeeper.name}:2181"
}

module "pulsar-proxy" {
  source    = "../../modules/pulsar/proxy"
  name      = "pulsar-proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  configurationStoreServers = "${module.zookeeper.name}:2181"
  zookeeper                 = "${module.zookeeper.name}:2181"
}

resource "k8s_extensions_v1beta1_ingress" "pulsar-proxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.pulsar-proxy.name}.*",
    }
    name      = module.pulsar-proxy.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.pulsar-proxy.name
      http {
        paths {
          backend {
            service_name = module.pulsar-proxy.name
            service_port = "8080"
          }
          path = "/"
        }
      }
    }
  }
}

module "pulsar-websocket" {
  source    = "../../modules/pulsar/websocket"
  name      = "pulsar-websocket"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  configurationStoreServers = "${module.zookeeper.name}:2181"
}

resource "k8s_extensions_v1beta1_ingress" "pulsar-websocket" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.pulsar-websocket.name}.*",
    }
    name      = module.pulsar-websocket.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.pulsar-websocket.name
      http {
        paths {
          backend {
            service_name = module.pulsar-websocket.name
            service_port = "8080"
          }
          path = "/"
        }
      }
    }
  }
}

module "pulsar-dashboard" {
  source    = "../../modules/pulsar/dashboard"
  name      = "pulsar-dashboard"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  SERVICE_URL = "http://${module.pulsar.name}:8080"
}

resource "k8s_extensions_v1beta1_ingress" "pulsar-dashboard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.pulsar-dashboard.name}.*",
    }
    name      = module.pulsar-dashboard.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.pulsar-dashboard.name
      http {
        paths {
          backend {
            service_name = module.pulsar-dashboard.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}