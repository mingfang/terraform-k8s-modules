resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "email-engine" {
  source = "../../modules/email-engine"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  EENGINE_REDIS = "redis://${module.redis.name}:${module.redis.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.email-engine.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.email-engine.name
            service_port = module.email-engine.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}