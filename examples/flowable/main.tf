resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "flowable" {
  source    = "../../modules/flowable"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env = [
    {
      name  = "SPRING_DATASOURCE_DRIVER-CLASS-NAME"
      value = "org.postgresql.Driver"
    },
    {
      name  = "SPRING_DATASOURCE_URL"
      value = "jdbc:postgresql://${module.postgres.name}:${module.postgres.ports[0].port}/flowable"
    },
    {
      name  = "SPRING_DATASOURCE_USERNAME"
      value = "flowable"
    },
    {
      name  = "SPRING_DATASOURCE_PASSWORD"
      value = "flowable"
    },
    {
      name  = "FLOWABLE_COMMON_APP_IDM-ADMIN_USER"
      value = "admin"
    },
    {
      name  = "FLOWABLE_COMMON_APP_IDM-ADMIN_PASSWORD"
      value = "test"
    },
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "flowable" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.flowable.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.flowable.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.flowable.name
            service_port = module.flowable.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  env_map = {
    POSTGRES_USER     = "flowable"
    POSTGRES_PASSWORD = "flowable"
    POSTGRES_DB       = "flowable"
  }
}


