resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = var.namespace

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 3
}

module "kafka" {
  source    = "../../modules/kafka"
  name      = "kafka"
  namespace = var.namespace

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = var.replicas

  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}


