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

module "zookeeper_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = var.namespace

  storage_class = module.zookeeper_storage.storage_class_name
  storage       = module.zookeeper_storage.storage
  replicas      = module.zookeeper_storage.replicas
}

module "kafka_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "kafka"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "kafka" {
  source    = "../../modules/kafka"
  name      = "kafka"
  namespace = var.namespace

  storage_class_name      = module.kafka_storage.storage_class_name
  storage                 = module.kafka_storage.storage
  replicas                = module.kafka_storage.replicas
  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}

module "postgres-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.postgres-storage.storage_class_name
  storage       = module.postgres-storage.storage
  replicas      = module.postgres-storage.replicas
  image         = "postgres:11.1-alpine"

  POSTGRES_USER     = "openbankingproject"
  POSTGRES_PASSWORD = "openbankingproject"
  POSTGRES_DB       = "openbankingproject"
}

module "open-banking-project-api" {
  source    = "../../modules/open-banking-project"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  OBP_CONNECTOR             = "kafka_vMay2019"
  OBP_KAFKA_BOOTSTRAP_HOSTS = "${module.kafka.name}:9092"
  OBP_DB_DRIVER             = "org.postgresql.Driver"
  OBP_DB_URL                = "jdbc:postgresql://${module.postgres.name}:5432/openbankingproject?user=openbankingproject&password=openbankingproject"
}

resource "k8s_extensions_v1beta1_ingress" "open-banking-project-api" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "openbanking.*"
    }
    name      = module.open-banking-project-api.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.open-banking-project-api.name
      http {
        paths {
          backend {
            service_name = module.open-banking-project-api.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }
  }
}

