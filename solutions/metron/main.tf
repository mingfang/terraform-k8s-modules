variable name {
  default = "metron"
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
  source        = "../../modules/zookeeper"
  name          = "${var.name}-zookeeper"
  namespace     = "${var.namespace}"
  storage_class = "${var.zookeeper_storage_class}"
  storage       = "${var.zookeeper_storage}"
  replicas      = "${var.zookeeper_count}"
}

module "kafka" {
  source                  = "../../modules/kafka"
  name                    = "${var.name}-kafka"
  namespace               = "${var.namespace}"
  storage_class_name      = "${var.kafka_storage_class}"
  storage                 = "${var.kafka_storage}"
  replicas                = "${var.kafka_count}"
  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}

module "hadoop_master" {
  source    = "../../modules/hadoop/master"
  namespace = "${var.namespace}"
}

module "hadoop_node" {
  source          = "../../modules/hadoop/node"
  namespace       = "${var.namespace}"
  namenode        = "${module.hadoop_master.name}"
  resourcemanager = "${module.hadoop_master.name}"
}

module "nifi" {
  source    = "../../modules/nifi"
  namespace = "${var.namespace}"
}

module "storm_nimbus" {
  source                  = "../../modules/storm-nimbus"
  namespace               = "${var.namespace}"
  storm_zookeeper_servers = ["${module.zookeeper.name}"]
}

locals {
  nimbus_seeds = ["${module.storm_nimbus.name}-0.${module.storm_nimbus.name}.${var.namespace}.svc.cluster.local"]
}

module "storm_supervisor" {
  source                  = "../../modules/storm-supervisor"
  name                    = "${var.name}-storm-supervisor"
  namespace               = "${var.namespace}"
  storm_zookeeper_servers = ["${module.zookeeper.name}"]
  nimbus_seeds            = ["${local.nimbus_seeds}"]

  supervisor_slots_ports = [
    {
      name = "worker-0"
      port = 6700
    },
    {
      name = "worker-1"
      port = 6701
    },
    {
      name = "worker-2"
      port = 6702
    },
    {
      name = "worker-3"
      port = 6703
    },
  ]
}

module "metron" {
  source                  = "../../modules/metron"
  name                    = var.name
  namespace               = "${var.namespace}"
  storm_zookeeper_servers = ["${module.zookeeper.name}"]
  nimbus_seeds            = ["${local.nimbus_seeds}"]
}
