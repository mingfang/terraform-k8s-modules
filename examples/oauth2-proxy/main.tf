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

module "oauth2-proxy" {
  source    = "../../modules/oauth2-proxy"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas

  env_map = {
    OAUTH2_PROXY_HTTP_ADDRESS = "0.0.0.0:4180"

    OAUTH2_PROXY_PROVIDER        = "oidc"
    OAUTH2_PROXY_CLIENT_ID       = var.client_id
    OAUTH2_PROXY_CLIENT_SECRET   = var.client_secret
    OAUTH2_PROXY_OIDC_ISSUER_URL = var.issuer_url
    OAUTH2_PROXY_REDIRECT_URL    = "https://${var.namespace}.rebelsoft.com/oauth2/callback"

    OAUTH2_PROXY_EMAIL_DOMAINS     = "*"
    OAUTH2_PROXY_WHITELIST_DOMAINS = ".rebelsoft.com"

    OAUTH2_PROXY_COOKIE_NAME             = var.namespace
    OAUTH2_PROXY_COOKIE_DOMAINS          = ".rebelsoft.com"
    OAUTH2_PROXY_COOKIE_SECRET           = "ApOM08XDXwwHu4nVtlbsdA=="
    OAUTH2_PROXY_COOKIE_EXPIRE           = "168h"
    OAUTH2_PROXY_COOKIE_CSRF_PER_REQUEST = "true"
    OAUTH2_PROXY_COOKIE_CSRF_EXPIRE      = "5m"

    # redis session
    OAUTH2_PROXY_SESSION_STORE_TYPE   = "redis"
    OAUTH2_PROXY_REDIS_CONNECTION_URL = "redis://${module.redis.name}:${module.redis.ports.0.port}"

    OAUTH2_PROXY_SCOPE                     = "openid profile email"
    OAUTH2_PROXY_REVERSE_PROXY             = "true"
    OAUTH2_PROXY_SET_XAUTHREQUEST          = "true"
    OAUTH2_PROXY_SET_AUTHORIZATION_HEADER  = "true"
    OAUTH2_PROXY_PASS_AUTHORIZATION_HEADER = "true"
    OAUTH2_PROXY_PASS_USER_HEADERS         = "true"

    OAUTH2_PROXY_INSECURE_OIDC_ALLOW_UNVERIFIED_EMAIL = "true"
    OAUTH2_PROXY_SSL_INSECURE_SKIP_VERIFY             = "true"
    OAUTH2_PROXY_SSL_UPSTREAM_INSECURE_SKIP_VERIFY    = "true"
    OAUTH2_PROXY_CODE_CHALLENGE_METHOD                = "S256"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "160k"
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
