resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

/* Postgres https://www.postgresql.org */

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  image     = "postgres:15.1"

  storage_class = "cephfs-csi"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "postgres_init_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
}

module "postgres_init" {
  source    = "../../modules/kubernetes/job"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "postgres:15.1"

  env_map = {
    PGHOST            = module.postgres.name
    PGUSER            = "postgres"
    PGPASSWORD        = "postgres"
    PGDATABASE        = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
  configmap = module.postgres_init_config.config_map

  command = [
    "bash",
    "-c",
    <<-EOF
    until pg_isready; do
      echo 'Waiting to start...'
      sleep 5
    done

    cd /config
    shopt -s nullglob
    for sql in {0,9}*.sql; do
        echo "$0: running $sql"
        psql -v ON_ERROR_STOP=0 -f "$sql"
    done
    EOF
  ]
}

/* PostgREST https://docs.postgrest.org */

module "postgrest" {
  source    = "../../modules/generic-deployment-service"
  name      = "postgrest"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "postgrest/postgrest:v12.2.3"
  ports = [
    { name = "tcp", port = 3000 },
    { name = "admin", port = 3001 },
  ]

  env_map = {
    PGRST_DB_URI             = "postgres://authenticator:postgres@${module.postgres.name}.${var.namespace}.svc.cluster.local:${module.postgres.ports.0.port}/postgres?sslmode=disable"
    PGRST_DB_SCHEMAS         = "public"
    PGRST_DB_ANON_ROLE       = "anon"
    PGRST_DB_CHANNEL_ENABLED = "true"
    PGRST_DB_PLAN_ENABLED    = "true"
    PGRST_DB_POOL            = "10"
    PGRST_DB_USE_LEGACY_GUCS = "false"
    PGRST_LOG_LEVEL          = "info"
    PGRST_ADMIN_SERVER_PORT  = "3001"

    PGRST_OPENAPI_SERVER_PROXY_URI = "https://${var.namespace}.rebelsoft.com"
    PGRST_OPENAPI_SECURITY_ACTIVE  = "true"

    PGRST_ROLE_CLAIM_KEY       = ".postgrest"
    PGRST_JWT_SECRET_IS_BASE64 = "false"
    PGRST_JWT_SECRET           = <<-EOF
    {"kty":"RSA","e":"AQAB","kid":"6917c621-6601-4cda-9d62-58820f45f445","n":"i4Ugl8Mi-0cWj9BqIo14Ivc9lxPKvabSi561IohP950SSqyrGw4AzWFUE5ArjIBu2XSr7kp4TBAL4H4jSQfN7bTRUQnJmMAyxRwS2jRe4VFOE0XgqwMQFkXoymUVBsV2-XhwoAVr78UjjU7BjGbZYdzbIBjmKvJxhOrEBuLafYlU2TWzATwUrV0q7UtAUhHzVGu-KlHk5z6YPLdbYdHCBc1irO6rBuCAILeSNULkLPtRHa-UhyNCcXEkJG6utgSs0fYCfZVqZdyvkl-i60hAcxspE8tkJNE06ewLl7xQJnc9AdjPm9emZ7WS8I9xvSexcj6B84IMJUl2LfIgvcjE4Q"}
    EOF
  }
}

/* Swagger UI https://swagger.io/docs/open-source-tools/swagger-ui */

module "swagger-ui" {
  source    = "../../modules/generic-deployment-service"
  name      = "swagger-ui"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "swaggerapi/swagger-ui"
  ports     = [{ name = "tcp", port = 8080 }]

  env_map = {
    BASE_URL = "/swagger"
    URL      = "https://${var.namespace}.rebelsoft.com"
  }
}

/* Ingress */

resource "k8s_networking_k8s_io_v1_ingress" "postgrest" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                   = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size" = "1024k"
      "nginx.ingress.kubernetes.io/proxy-body-size"   = "10240m"

      "nginx.ingress.kubernetes.io/enable-cors"        = "true"
      "nginx.ingress.kubernetes.io/cors-allow-headers" = "keep-alive,user-agent,x-requested-with,x-request-id,if-modified-since,cache-control,content-type,range,authorization,apikey,x-client-info,accept-profile,prefer,content-profile,range-unit,x-upsert"
      "nginx.ingress.kubernetes.io/cors-allow-origin"  = "https://*.rebelsoft.com"

      "nginx.ingress.kubernetes.io/auth-url"              = "https://oauth.rebelsoft.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin"           = "https://oauth.rebelsoft.com/oauth2/start?rd=https://$host$escaped_request_uri"
      "nginx.ingress.kubernetes.io/auth-response-headers" = "x-auth-request-user, x-auth-request-groups, x-auth-request-email, x-auth-request-preferred-username, x-auth-request-access-token, authorization, x-forwarded-groups, x-forwarded-user, remote_user"
      "nginx.ingress.kubernetes.io/auth-cache-key"        = "$cookie__oauth2_proxy"

      "nginx.ingress.kubernetes.io/server-snippet" = <<-EOF
        # https://docs.postgrest.org/en/v12/explanations/nginx.html
        # support /endpoint/:id url style
        location ~ ^/([a-z_]+)/([0-9]+) {
          resolver kube-dns.kube-system.svc.cluster.local valid=5s;
          set $target ${module.postgrest.name}.${var.namespace}.svc.cluster.local:${module.postgrest.ports.0.port};

          # make the response singular
          proxy_set_header Accept 'application/vnd.pgrst.object+json';

          proxy_pass http://$target/$1?id=eq.$2;
        }

        location /swagger/ {
          resolver kube-dns.kube-system.svc.cluster.local valid=5s;
          set $target ${module.swagger-ui.name}.${var.namespace}.svc.cluster.local:${module.swagger-ui.ports.0.port};
          proxy_pass http://$target;
        }
        EOF
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.postgrest.name
              port {
                number = module.postgrest.ports.0.port
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


resource "k8s_networking_k8s_io_v1_ingress" "postgrest_admin" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-admin.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-admin"
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = "${var.namespace}-admin"
      http {
        paths {
          backend {
            service {
              name = module.postgrest.name
              port {
                number = module.postgrest.ports.1.port
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
