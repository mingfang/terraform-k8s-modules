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
      value = "jdbc:postgresql://${module.cockroachdb.name}:${module.cockroachdb.ports[0].port}/defaultdb"
    },
    {
      name  = "SPRING_DATASOURCE_USERNAME"
      value = "root"
    },
    {
      name  = "SPRING_DATASOURCE_PASSWORD"
      value = ""
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

module "cockroachdb" {
  source    = "../../modules/cockroachdb"
  name      = "cockroachdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = null
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "cockroachdb" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "cockroachdb-${var.namespace}.*"
    }
    name      = module.cockroachdb.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.cockroachdb.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.cockroachdb.name
            service_port = module.cockroachdb.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}


