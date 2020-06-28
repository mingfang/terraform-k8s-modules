resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zeebe" {
  source    = "../../modules/zeebe/zeebe"
  name      = "zeebe"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/zeebe:latest"

  replicas      = 1
  storage       = "1Gi"
  storage_class = var.storage_class_name

  ZEEBE_LOG_LEVEL = "debug"

  env = [
    {
      name  = "ZEEBE_BROKER_EXPORTERS_HAZELCAST_CLASSNAME"
      value = "io.zeebe.hazelcast.exporter.HazelcastExporter"
    },
    {
      name  = "ZEEBE_BROKER_EXPORTERS_HAZELCAST_JARPATH"
      value = "/usr/local/zeebe/exporters/zeebe-hazelcast-exporter.jar"
    },
  ]
}

module "http-worker" {
  source    = "../../modules/zeebe/http-worker"
  name      = "http-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ZEEBE_CLIENT_BROKER_CONTACTPOINT = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

module "simple-monitor" {
  source    = "../../modules/zeebe/simple-monitor"
  name      = "simple-monitor"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ZEEBE_CLIENT_BROKER_CONTACTPOINT         = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
  ZEEBE_CLIENT_WORKER_HAZELCAST_CONNECTION = "${module.zeebe.name}:5701"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "simple-monitor" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "zeebe-monitor.*"
    }
    name      = "simple-monitor"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.simple-monitor.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.simple-monitor.name
            service_port = module.simple-monitor.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

/*
module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.10"
  replicas      = 1

  env = [
    {
      name = "discovery.type"
      value = "single-node"
    },
    {
      name = "discovery.seed_hosts"
      value = ""
    },
    {
      name = "cluster.initial_master_nodes"
      value = ""
    },
  ]
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

module "operate" {
  source    = "../../modules/zeebe/operate"
  name      = "operate"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CAMUNDA_OPERATE_ELASTICSEARCH_HOST       = module.elasticsearch.name
  CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST  = module.elasticsearch.name
  CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "zeebe-example.*"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.operate.name
            service_port = module.operate.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
*/






