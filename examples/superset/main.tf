resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  env_map = {
    POSTGRES_USER     = "superset"
    POSTGRES_PASSWORD = "superset"
    POSTGRES_DB       = "superset"
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
}

module "datasources" {
  source    = "../../modules/kubernetes/config-map"
  name      = "datasources"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/datasources.yaml"
}

resource "random_password" "secret_key" {
  length  = 16
  special = false
}

module "env" {
  source = "../../modules/kubernetes/env"
  from-map = {
    DATABASE_DIALECT  = "postgresql"
    DATABASE_HOST     = module.postgres.name
    DATABASE_PORT     = module.postgres.ports[0].port
    DATABASE_DB       = "superset"
    DATABASE_USER     = "superset"
    DATABASE_PASSWORD = "superset"
    REDIS_HOST        = module.redis.name
    REDIS_PORT        = module.redis.ports[0].port

    FLASK_ENV      = "production"
    SUPERSET_ENV   = "production",
    SECRET_KEY     = base64encode(random_password.secret_key.result)
    CYPRESS_CONFIG = false
    SUPERSET_PORT  = 8088
    ADMIN_USERNAME = "admin",
    ADMIN_PASSWORD = "admin",

    SUPERSET_LOAD_EXAMPLES = "yes"
  }
}

module "superset" {
  source    = "../../modules/superset"
  name      = "superset"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }

  env                   = module.env.kubernetes_env
  config_configmap      = module.config.config_map
  datasources_configmap = module.datasources.config_map
}

module "superset-beat" {
  source    = "../../modules/superset/celery"
  name      = "superset-beat"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }

  env              = module.env.kubernetes_env
  config_configmap = module.config.config_map
  type             = "beat"
}

module "superset-worker" {
  source    = "../../modules/superset/celery"
  name      = "superset-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }
  replicas = 2

  env              = module.env.kubernetes_env
  config_configmap = module.config.config_map
  type             = "worker"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "superset" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User, X-Auth-Request-Email"

/*
      "nginx.ingress.kubernetes.io/configuration-snippet" = <<-EOF
        ssi on;
        ssi_silent_errors on;
        sub_filter '<body >' '<body><!--# include virtual="/menu/" -->';
        sub_filter_once on;
        proxy_set_header Accept-Encoding "";
      EOF
      "nginx.ingress.kubernetes.io/server-snippet" = <<-EOF
        location ~ /menu {
          resolver kube-dns.kube-system.svc.cluster.local valid=5s;
          set $target http://intellij-0.intellij.intellij.svc.cluster.local:3000;
          proxy_pass $target;
          proxy_set_header Accept-Encoding "";
        }
      EOF
*/
    }
    name      = module.superset.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.superset.name
            service_port = module.superset.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
