resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_limit_range" "this" {
  metadata {
    name      = k8s_core_v1_namespace.this.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    limits {
      default_request = {
        "cpu" = "500m"
      }
      type = "Container"
    }
  }
}

module "httpbin" {
  source    = "../../modules/httpbin"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth2-proxy-example.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth2-proxy-example.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "x-auth-request-user, x-auth-request-groups, x-auth-request-email, x-auth-request-preferred-username, x-auth-request-access-token, authorization"
      "nginx.ingress.kubernetes.io/auth-cache-key"        = "$cookie__oauth2_proxy"
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
            service_name = module.httpbin.service.metadata[0].name
            service_port = module.httpbin.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
