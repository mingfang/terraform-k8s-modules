/**
 * [Debezium](https://debezium.io)
 *
 * This solution sets up:
 * - a [Kafka](https://kafka.apache.org) cluster
 * - a [Zookeeper](https://zookeeper.apache.org) cluster
 * - two [Kafka Connect](https://docs.confluent.io/current/connect/index.html) instances (one for source and another for sink).
 * - [Kafka Connect UI](http://kafka-connect-ui.landoop.com)
 * - [Kafka Topic UI](http://kafka-topics-ui.landoop.com)
 *
 * Examples:
 * - [Sync MySql to Elasticsearch](https://github.com/mingfang/terraform-provider-k8s/tree/master/examples/debezium-mysql-elasticsearch)
 * - [Sync Postgres to Elasticsearch](https://github.com/mingfang/terraform-provider-k8s/tree/master/examples/debezium-postgres-elasticsearch)
 */


module "zookeeper" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"
  name      = "${var.name}-zookeeper"
  namespace = var.namespace

  storage_class_name = var.zookeeper_storage_class
  storage            = var.zookeeper_storage
  replicas           = var.zookeeper_count
}

module "kafka" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka"
  name      = "${var.name}-kafka"
  namespace = var.namespace

  storage_class_name      = var.kafka_storage_class
  storage                 = var.kafka_storage
  replicas                = var.kafka_count
  kafka_zookeeper_connect = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}

module "kafka-rest-proxy" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-rest-proxy"
  name      = "${var.name}-kafka-rest-proxy"
  namespace = var.namespace

  zookeeper = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
}

module "kafka-topic-ui" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-topic-ui"
  name      = "${var.name}-kafka-topic-ui"
  namespace = var.namespace

  kafka_rest_proxy = "http://${module.kafka-rest-proxy.name}:8000"

  annotations = {
    "nginx" = "[{\"http\": [{\"server\": \"${var.name}-kafka-topic-ui.*\", \"paths\": [{\"path\": \"/\"}]}]}]"
  }
}

module "kafka-connect-ui" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect-ui"
  name      = "${var.name}-kafka-connect-ui"
  namespace = var.namespace

  kafka_connect = "http://${module.kafka-connect-source.name}:8083;source,http://${module.kafka-connect-sink.name}:8083;sink"

  annotations = {
    "nginx" = "[{\"http\": [{\"server\": \"${var.name}-kafka-connect-ui.*\", \"paths\": [{\"path\": \"/\"}]}]}]"
  }
}

module "kafka-connect-source" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect"
  name      = "${var.name}-connect-source"
  namespace = var.namespace
  image     = "debezium/connect:${var.debezium-version}"

  bootstrap_servers = "${module.kafka.name}:9092"
}

module "kafka-connect-sink" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect"
  name      = "${var.name}-connect-sink"
  namespace = var.namespace
  image     = "registry.rebelsoft.com/debezium-jdbc-es"

  bootstrap_servers = "${module.kafka.name}:9092"
}

