resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

module "cortex" {
  source    = "../../modules/cortex/cortex"
  name      = "cortex"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  cassandra = module.cassandra.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "cortex" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "cortex.*"
    }
    name      = module.cortex.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.cortex.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.cortex.name
            service_port = module.cortex.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "cortex-push" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "cortex-push.*"
      "nginx.ingress.kubernetes.io/configuration-snippet" : "proxy_set_header X-Scope-OrgID rebelsoft;"
    }
    name      = "${module.cortex.name}-push"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.cortex.name}-push.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.cortex.name
            service_port = module.cortex.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "agent" {
  source    = "../../modules/cortex/agent"
  name      = "agent"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  remote_write_url = "http://cortex-push.rebelsoft.com/api/prom/push"
  log_level        = "debug"
}