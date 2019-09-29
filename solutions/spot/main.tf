variable name {
  default = "spot"
}

variable namespace {
  default = ""
}

variable "zookeeper_storage_class" {}

variable "zookeeper_storage" {}

variable "zookeeper_count" {}

variable "kafka_storage_class" {}

variable "kafka_storage" {}

variable "kafka_count" {}

module "zookeeper" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"

  //  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"
  name               = "${var.name}-zookeeper"
  namespace          = "${var.namespace}"
  storage_class_name = "${var.zookeeper_storage_class}"
  storage            = "${var.zookeeper_storage}"
  replicas           = "${var.zookeeper_count}"
}

module "kafka" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka"

  //  source                  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka"
  name                    = "${var.name}-kafka"
  namespace               = "${var.namespace}"
  storage_class_name      = "${var.kafka_storage_class}"
  storage                 = "${var.kafka_storage}"
  replicas                = "${var.kafka_count}"
  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}

module "hadoop_master" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/hadoop-master"
  namespace = "${var.namespace}"
}

module "hadoop_node" {
  source          = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/hadoop-node"
  namespace       = "${var.namespace}"
  namenode        = "${module.hadoop_master.name}"
  resourcemanager = "${module.hadoop_master.name}"
}

module "spot_ingest" {
  source           = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/spot-ingest"
  namespace        = "${var.namespace}"
  kafka_server     = "${module.kafka.name}"
  kafka_port       = "${lookup(module.kafka.ports[0], "port")}"
  zookeeper_server = "${module.zookeeper.name}"
  zookeeper_port   = "${lookup(module.zookeeper.ports[0], "port")}"
  namenode         = "${module.hadoop_master.name}"
}
