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
  replicas      = 1
}

module "kafka" {
  source    = "../../modules/confluentinc/kafka"
  name      = "kafka"
  namespace = var.namespace

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 3

  KAFKA_ZOOKEEPER_CONNECT = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
}

module "schema-registry" {
  source    = "../../modules/confluentinc/schema-registry"
  name      = "schema-registry"
  namespace = var.namespace

  SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS = "${module.kafka.name}:${module.kafka.ports[0].port}"
}

module "connect" {
  source    = "../../modules/confluentinc/connect"
  name      = "connect"
  namespace = var.namespace
  replicas  = 3
  image     = "registry.rebelsoft.com/kafka-connect"

  CONNECT_BOOTSTRAP_SERVERS   = "${module.kafka.name}:${module.kafka.ports[0].port}"
  CONNECT_SCHEMA_REGISTRY_URL = "http://${module.schema-registry.name}:${module.schema-registry.ports[0].port}"
}

module "ksqldb-server" {
  source    = "../../modules/confluentinc/ksqldb-server"
  name      = "ksqldb-server"
  namespace = var.namespace
  replicas  = 3
  //  image     = "registry.rebelsoft.com/ksqldb-server"

  KSQL_BOOTSTRAP_SERVERS        = "${module.kafka.name}:${module.kafka.ports[0].port}"
  KSQL_KSQL_SCHEMA_REGISTRY_URL = "http://${module.schema-registry.name}:${module.schema-registry.ports[0].port}"
  KSQL_KSQL_CONNECT_URL         = "http://${module.connect.name}:${module.connect.ports[0].port}"
}

module "control-center" {
  source    = "../../modules/confluentinc/control-center"
  name      = "control-center"
  namespace = var.namespace

  CONTROL_CENTER_ZOOKEEPER_CONNECT   = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
  CONTROL_CENTER_BOOTSTRAP_SERVERS   = "${module.kafka.name}:${module.kafka.ports[0].port}"
  CONTROL_CENTER_SCHEMA_REGISTRY_URL = "http://${module.schema-registry.name}:${module.schema-registry.ports[0].port}"

  env = [
    {
      name  = "CONTROL_CENTER_KSQL_${module.ksqldb-server.name}_URL"
      value = "${module.ksqldb-server.name}:${module.ksqldb-server.ports[0].port}"
    },
    {
      name  = "CONTROL_CENTER_CONNECT_CLUSTER"
      value = "${module.connect.name}:${module.connect.ports[0].port}"
    },
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "control-center" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "kafka-example.*"
    }
    name      = module.control-center.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}-control-center"
      http {
        paths {
          backend {
            service_name = module.control-center.name
            service_port = module.control-center.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
