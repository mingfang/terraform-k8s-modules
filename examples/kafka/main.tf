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

module "zookeeper_storage" {
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
  namespace = var.namespace

  storage_class = module.zookeeper_storage.storage_class_name
  storage       = module.zookeeper_storage.storage
  replicas      = module.zookeeper_storage.replicas
}

module "kafka_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-kafka"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "kafka" {
  source    = "../../modules/kafka"
  name      = "${var.name}-kafka"
  namespace = var.namespace

  storage_class_name      = module.kafka_storage.storage_class_name
  storage                 = module.kafka_storage.storage
  replicas                = module.kafka_storage.replicas
  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}


