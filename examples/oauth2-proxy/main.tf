resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "oauth2-proxy" {
  source    = "../../modules/oauth2-proxy"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    OAUTH2_PROXY_PROVIDER        = "oidc"
    OAUTH2_PROXY_CLIENT_ID       = "oauth2-proxy-example"
    OAUTH2_PROXY_CLIENT_SECRET   = "6ca6d3c7-2093-4b07-bbe1-533f9149226b"
    OAUTH2_PROXY_OIDC_ISSUER_URL = "https://keycloak.rebelsoft.com/auth/realms/rebelsoft"
    OAUTH2_PROXY_REDIRECT_URL    = "https://${var.namespace}.rebelsoft.com/oauth2/callback"

    OAUTH2_PROXY_EMAIL_DOMAINS     = "*"
    OAUTH2_PROXY_COOKIE_DOMAINS    = ".rebelsoft.com"
    OAUTH2_PROXY_WHITELIST_DOMAINS = ".rebelsoft.com"
    OAUTH2_PROXY_COOKIE_SECRET     = "ApOM08XDXwwHu4nVtlbsdA=="
    OAUTH2_PROXY_COOKIE_REFRESH    = "1m"
    OAUTH2_PROXY_COOKIE_EXPIRE     = "30m"

    OAUTH2_PROXY_SCOPE                     = "openid profile email"
    OAUTH2_PROXY_REVERSE_PROXY             = "true"
    OAUTH2_PROXY_SET_XAUTHREQUEST          = "true"
    OAUTH2_PROXY_SET_AUTHORIZATION_HEADER  = "true"
    OAUTH2_PROXY_PASS_AUTHORIZATION_HEADER = "true"
    OAUTH2_PROXY_PASS_USER_HEADERS         = "true"

    OAUTH2_PROXY_INSECURE_OIDC_ALLOW_UNVERIFIED_EMAIL = "true"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                   = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size" = "160k"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.oauth2-proxy.name
            service_port = module.oauth2-proxy.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
