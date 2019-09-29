/*
Pulsar test

- Start a container with Pulsar binary
docker run -it apachepulsar/pulsar-all:latest bash

- Create default namespace
./bin/pulsar-admin --admin-url http://pulsar-proxy.192.168.2.249.nip.io:80 namespaces create public/default
./bin/pulsar-admin --admin-url http://pulsar-proxy.192.168.2.249.nip.io:80 namespaces list public

-- Produce
./bin/pulsar-client --url pulsar://192.168.2.249:6650 produce my-topic --messages "hello-pulsar"

-- Consume
./bin/pulsar-client --url pulsar://192.168.2.249:6650 consume my-topic -s "first-subscription"

- Generate sample data
./bin/pulsar-admin sources localrun --name generator --destinationTopicName generator_test -a ./connectors/pulsar-io-data-generator-2.4.0.nar --broker-service-url pulsar://192.168.2.249:6650
./bin/pulsar-admin sources localrun --name generator --destinationTopicName generator_test -a ./connectors/pulsar-io-data-generator-2.4.0.nar --broker-service-url ws://pulsar-websocket.192.168.2.249.nip.io:80

- Start SQL client (optional)
./bin/pulsar sql --server http://pulsar-sql.192.168.2.249.nip.io

- Query sample data
./bin/pulsar sql --server http://pulsar-sql.192.168.2.249.nip.io --execute 'select * from pulsar."public/default".generator_test;'

*/

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

module "zookeeper-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.zookeeper-storage.replicas
  storage       = module.zookeeper-storage.storage
  storage_class = module.zookeeper-storage.storage_class_name
}

module "bookkeeper-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-bookkeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "bookkeeper" {
  source        = "../../modules/pulsar/bookkeeper"
  name          = "bookkeeper"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = module.bookkeeper-storage.replicas
  storage       = module.bookkeeper-storage.storage
  storage_class = module.bookkeeper-storage.storage_class_name

  zookeeper = "${module.zookeeper.name}:2181"
}

module "pulsar-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-pulsar"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "pulsar" {
  source                    = "../../modules/pulsar/broker"
  name                      = "pulsar"
  namespace                 = k8s_core_v1_namespace.this.metadata[0].name
  replicas                  = module.pulsar-storage.replicas
  storage                   = module.pulsar-storage.storage
  storage_class             = module.pulsar-storage.storage_class_name
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
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
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

// Needs TCP proxing by Ingress (above)
module "pulsar-proxy" {
  source    = "../../modules/pulsar/proxy"
  name      = "pulsar-proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  configurationStoreServers = "${module.zookeeper.name}:2181"
  zookeeper                 = "${module.zookeeper.name}:2181"
}

// be sure to avoid load_balancer_ip conflict
module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = "${var.name}-ingress"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = "${var.name}-ingress"
  load_balancer_ip = "192.168.2.249"
  service_type     = "LoadBalancer"

  tcp_services_data = {
    "6650" = "${k8s_core_v1_namespace.this.metadata[0].name}/${module.pulsar-proxy.name}:6650"
  }
}

resource "k8s_extensions_v1beta1_ingress" "pulsar-proxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
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
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
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
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
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