module "oauth2" {
  source                     = "../../modules/kubernetes/oauth2-proxy"
  name                       = "oauth2"
  namespace                  = k8s_core_v1_namespace.this.metadata[0].name
//  OAUTH2_PROXY_CLIENT_ID     = "a4ede3c2e1936beffc91"
//  OAUTH2_PROXY_CLIENT_SECRET = "cd49b2ebe9d6e5ec14376ecec3c6199cbfd2fc1f"
  OAUTH2_PROXY_CLIENT_ID     = "0a7d30c5558fd428c860"
  OAUTH2_PROXY_CLIENT_SECRET = "fc1bce10de79e4f8fa88bbd1fc1d0435582b1905"
  OAUTH2_PROXY_COOKIE_SECRET = "cd49b2ebe9d6e5ec14376ecec3c6199cbfd2fc1f"
  cookie_domain = ".rebelsoft.com"
}

resource "k8s_extensions_v1beta1_ingress" "oauth2" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "auth.*"
      "certmanager.k8s.io/cluster-issuer"           = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/configuration-snippet" = <<-EOF
        if ($request_uri ~ ^/redirect/(.*)) {
          return 307 https://$1$is_args$args;
        }
      EOF
    }
    name      = "oauth2-ingress"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "auth.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.oauth2.service.metadata[0].name
            service_port = module.oauth2.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "auth.rebelsoft.com"
      ]
      secret_name = "auth-tls"
    }
  }
}
