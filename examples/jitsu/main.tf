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

module "jitsu" {
  source    = "../../modules/jitsu"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    REDIS_URL = "redis://${module.redis.name}:${module.redis.ports[0].port}"
    TERM      = "xterm-256color"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.jitsu.name
              port {
                number = module.jitsu.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}


/*
curl -i -X POST -H "Content-Type: application/json"   -H 'X-Auth-Token: s2s.f07h2oqh02fd7d0j3fdl4c.qsi6radqfwpwvq8sdvtjqe' \
  --data-binary '{"test_str_field": "str", "test_int_field": 42}' 'https://jitsu-example.rebelsoft.com/api/v1/s2s/event'
*/