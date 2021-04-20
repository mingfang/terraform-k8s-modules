resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1
}

module "kafka" {
  source    = "../../modules/confluentinc/kafka"
  name      = "kafka"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage_class = "cephfs"
  storage       = "1Gi"

  KAFKA_ZOOKEEPER_CONNECT = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
}

module "infinispan" {
  source    = "../../modules/infinispan"
  name      = "infinispan"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  USER = "infinispan"
  PASS = "infinispan"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "infinispan" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "infinispan-${var.namespace}.*"
    }
    name      = module.infinispan.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.infinispan.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.infinispan.name
            service_port = module.infinispan.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

locals {
  env = [
    {
      name  = "SCRIPT_DEBUG"
      value = "true"
    },
    {
      name  = "KAFKA_BOOTSTRAP_SERVERS"
      value = "${module.kafka.name}:${module.kafka.ports[0].port}"
    },
    {
      name  = "QUARKUS_INFINISPAN_CLIENT_SERVER_LIST"
      value = "${module.infinispan.name}:${module.infinispan.ports[0].port}"
    },
    {
      name  = "QUARKUS_INFINISPAN_CLIENT_AUTH_USERNAME"
      value = "infinispan"
    },
    {
      name  = "QUARKUS_INFINISPAN_CLIENT_AUTH_PASSWORD"
      value = "infinispan"
    },
    {
      name  = "KOGITO_DATAINDEX_HTTP_URL"
      value = "https://dataindex-${var.namespace}.rebelsoft.com:443"
    },
    {
      name  = "KOGITO_DATAINDEX_WS_URL"
      value = "wss://dataindex-${var.namespace}.rebelsoft.com:443"
    },
  ]
}

module "data-index-protobufs" {
  source    = "../../modules/kubernetes/config-map"
  name      = "data-index-protobufs"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-dir  = "${path.module}/protobufs"
}

module "data-index" {
  source    = "../../modules/kogito/data-index"
  name      = "data-index"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "checksum" = module.data-index-protobufs.checksum
  }
  //  image = "registry.rebelsoft.com/kogito-data-index-infinispan:latest"

  env = concat(local.env, [
    {
      name  = "KOGITO_SERVICE_URL"
      value = "https://dataindex-${var.namespace}.rebelsoft.com"
    }
  ])

  protobufs = module.data-index-protobufs.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "data-index" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dataindex-${var.namespace}.*"
    }
    name      = module.data-index.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.data-index.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.data-index.name
            service_port = module.data-index.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "explainability" {
  source    = "../../modules/kogito/explainability"
  name      = "explainability"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = concat(local.env, [
    {
      name  = "QUARKUS_EXPLAINABILITY_COMMUNICATION"
      value = "REST"
    }
  ])
}

module "trusty" {
  source    = "../../modules/kogito/trusty"
  name      = "trusty"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = local.env
}

module "jobs-service" {
  source    = "../../modules/kogito/jobs-service"
  name      = "jobs-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = local.env
}


module "jit-runner" {
  source    = "../../modules/kogito/jit-runner"
  name      = "jit-runner"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = local.env
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "jit-runner" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "jitrunner-${var.namespace}.*"
    }
    name      = module.jit-runner.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.jit-runner.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.jit-runner.name
            service_port = module.jit-runner.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "management-console" {
  source    = "../../modules/kogito/management-console"
  name      = "management-console"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = concat(local.env, [
    {
      name  = "KOGITO_SERVICE_URL"
      value = "https://management-${var.namespace}.rebelsoft.com"
    }
  ])

  //  image = "registry.rebelsoft.com/kogito-management-console:latest"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "console" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "console-${var.namespace}.*"
    }
    name      = module.management-console.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.management-console.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.management-console.name
            service_port = module.management-console.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.data-index.name
            service_port = module.data-index.ports[0].port
          }
          path = "/graphql"
        }
      }
    }
  }
}

module "task-console" {
  source    = "../../modules/kogito/task-console"
  name      = "task-console"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  KOGITO_DATAINDEX_HTTP_URL = "https://task-${var.namespace}.rebelsoft.com"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "task-console" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "task-${var.namespace}.*"
    }
    name      = module.task-console.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.task-console.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.task-console.name
            service_port = module.task-console.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.data-index.name
            service_port = module.data-index.ports[0].port
          }
          path = "/graphql"
        }
      }
    }
  }
}

module "trusty-ui" {
  source    = "../../modules/kogito/trusty-ui"
  name      = "trusty-ui"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  KOGITO_TRUSTY_ENDPOINT = "https://trusty-${var.namespace}.rebelsoft.com"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "trusty-ui" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "trusty-${var.namespace}.*"
    }
    name      = module.trusty-ui.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.trusty-ui.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.trusty-ui.name
            service_port = module.trusty-ui.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.trusty.name
            service_port = module.trusty.ports[0].port
          }
          path = "/graphql"
        }
      }
    }
  }
}
