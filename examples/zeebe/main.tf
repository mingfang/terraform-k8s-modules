resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

# Zeebe

module "zeebe" {
  source    = "../../modules/zeebe/zeebe"
  name      = "zeebe"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = var.storage_class_name

  ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR = 2
  ZEEBE_LOG_LEVEL                        = "debug"

  env = [
    {
      name  = "ZEEBE_BROKER_EXPORTERS_ELASTICSEARCH_CLASSNAME"
      value = "io.camunda.zeebe.exporter.ElasticsearchExporter"
    },
    {
      name  = "ZEEBE_BROKER_EXPORTERS_ELASTICSEARCH_ARGS_URL"
      value = "http://${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
    },
    {
      name  = "ZEEBE_BROKER_EXPORTERS_ELASTICSEARCH_ARGS_BULK_SIZE"
      value = 1
    }
  ]
}

# Workers

module "http-worker" {
  source    = "../../modules/zeebe/http-worker"
  name      = "http-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ZEEBE_CLIENT_BROKER_CONTACTPOINT = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

module "script-worker" {
  source    = "../../modules/zeebe/script-worker"
  name      = "script-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ZEEBE_CLIENT_BROKER_CONTACTPOINT = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

# Exporter

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  env = [
    #    {
    #      name  = "discovery.type"
    #      value = "single-node"
    #    },
  ]
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "elasticsearch" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.elasticsearch.name}-${var.namespace}.*"
    }
    name      = module.elasticsearch.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.elasticsearch.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.elasticsearch.name
            service_port = module.elasticsearch.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

# Tasklist

module "tasklist" {
  source    = "../../modules/zeebe/tasklist"
  name      = "tasklist"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CAMUNDA_TASKLIST_ELASTICSEARCH_URL      = "http://${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
  CAMUNDA_TASKLIST_ZEEBEELASTICSEARCH_URL = "http://${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
  CAMUNDA_TASKLIST_ZEEBE_GATEWAYADDRESS   = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "tasklist" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.tasklist.name}-${var.namespace}.*"
    }
    name      = module.tasklist.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.tasklist.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.tasklist.name
            service_port = module.tasklist.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

# Operate

module "operate" {
  source    = "../../modules/zeebe/operate"
  name      = "operate"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CAMUNDA_OPERATE_ELASTICSEARCH_URL      = "http://${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
  CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_URL = "http://${module.elasticsearch.name}:${module.elasticsearch.ports[0].port}"
  CAMUNDA_OPERATE_ZEEBE_GATEWAYADDRESS   = "${module.zeebe.name}:${module.zeebe.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "operate" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.operate.name}-${var.namespace}.*"
    }
    name      = module.operate.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.operate.name}-${var.namespace}"
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







