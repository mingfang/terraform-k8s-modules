resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "rabbitmq" {
  source    = "../../modules/rabbitmq"
  name      = "rabbitmq"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = null

  RABBITMQ_ERLANG_COOKIE = "RABBITMQ_ERLANG_COOKIE"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "management" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "rabbitmq-dataflow-example.*"
    }
    name      = module.rabbitmq.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.rabbitmq.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.rabbitmq.name
            service_port = module.rabbitmq.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}

module "mysql-dataflow" {
  source    = "../../modules/mysql"
  name      = "mysql-dataflow"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = null

  image               = "mariadb:latest"
  MYSQL_USER          = "dataflow"
  MYSQL_PASSWORD      = "dataflow"
  MYSQL_ROOT_PASSWORD = "dataflow"
  MYSQL_DATABASE      = "dataflow"
}

module "mysql-skipper" {
  source    = "../../modules/mysql"
  name      = "mysql-skipper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = null

  image               = "mariadb:latest"
  MYSQL_USER          = "skipper"
  MYSQL_PASSWORD      = "skipper"
  MYSQL_ROOT_PASSWORD = "skipper"
  MYSQL_DATABASE      = "skipper"
}

module "skipper-server" {
  source    = "../../modules/spring-dataflow/skipper-server"
  name      = "skipper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  RABBITMQ_HOST     = module.rabbitmq.name
  RABBITMQ_PORT     = module.rabbitmq.ports[0].port
  RABBITMQ_USERNAME = "guest"
  RABBITMQ_PASSWORD = "guest"
}

module "dataflow-server" {
  source    = "../../modules/spring-dataflow/dataflow-server"
  name      = "dataflow"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI = "http://${module.skipper-server.name}:${module.skipper-server.ports[0].port}/api"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "dataflow" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dataflow-example.*"
    }
    name      = module.dataflow-server.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.dataflow-server.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.dataflow-server.name
            service_port = module.dataflow-server.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
