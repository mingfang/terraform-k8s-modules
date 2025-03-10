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
    POSTGRES_USER     = "prefect"
    POSTGRES_PASSWORD = "prefect"
    POSTGRES_DB       = "prefect"
  }
}

module "hasura" {
  source    = "../../modules/hasura/graphql-engine"
  name      = "graphql-engine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  HASURA_GRAPHQL_DATABASE_URL   = "postgres://prefect:prefect@${module.postgres.name}:${module.postgres.ports[0].port}/prefect"
  HASURA_GRAPHQL_ENABLE_CONSOLE = "true"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "hasura" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "prefect-graphql-engine-example.*"
    }
    name      = module.hasura.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.hasura.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.hasura.name
            service_port = module.hasura.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "prefect-server" {
  source    = "../../modules/prefect/server"
  name      = "prefect-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PREFECT_SERVER__DATABASE__CONNECTION_URL = "postgres://prefect:prefect@${module.postgres.name}:${module.postgres.ports[0].port}/prefect"
  PREFECT_SERVER__HASURA__HOST             = module.hasura.name
  PREFECT_SERVER__HASURA__PORT             = module.hasura.ports[0].port
}

module "prefect-scheduler" {
  source    = "../../modules/prefect/scheduler"
  name      = "prefect-scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PREFECT_SERVER__HASURA__HOST = module.hasura.name
  PREFECT_SERVER__HASURA__PORT = module.hasura.ports[0].port
}

module "prefect-apollo" {
  source    = "../../modules/prefect/apollo"
  name      = "prefect-apollo"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  HASURA_API_URL         = "http://${module.hasura.name}:${module.hasura.ports[0].port}/v1alpha1/graphql"
  PREFECT_API_URL        = "http://${module.prefect-server.name}:${module.prefect-server.ports[0].port}/graphql/"
  PREFECT_API_HEALTH_URL = "http://${module.prefect-server.name}:${module.prefect-server.ports[0].port}/health"
}

module "prefect-agent" {
  source    = "../../modules/prefect/agent"
  name      = "prefect-agent"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PREFECT__CLOUD__API = "http://${module.prefect-apollo.name}:${module.prefect-apollo.ports[0].port}"
}

module "prefect-ui" {
  source    = "../../modules/prefect/ui"
  name      = "prefect-ui"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PREFECT_SERVER__GRAPHQL_URL = "/graphql"
}

module "nginx" {
  source    = "../../modules/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  default-conf = <<-EOF
    server {
      listen      80;

      location / {
        proxy_pass http://${module.prefect-ui.name}:${module.prefect-ui.ports[0].port};
      }

      location /graphql {
        proxy_pass http://${module.prefect-apollo.name}:${module.prefect-apollo.ports[0].port};
      }
    }
    EOF
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "prefect" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "prefect-example.*"
    }
    name      = module.nginx.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.nginx.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.nginx.name
            service_port = module.nginx.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
