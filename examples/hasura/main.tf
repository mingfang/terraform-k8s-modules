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
    POSTGRES_USER     = "hasura"
    POSTGRES_PASSWORD = "hasura"
    POSTGRES_DB       = "hasura"
  }
}

module "graphql-engine" {
  source    = "../../modules/hasura/graphql-engine"
  name      = "graphql-engine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  HASURA_GRAPHQL_DATABASE_URL   = "postgres://hasura:hasura@${module.postgres.name}:${module.postgres.ports[0].port}/hasura"
  HASURA_GRAPHQL_ENABLE_CONSOLE = "true"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.graphql-engine.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.graphql-engine.name
            service_port = module.graphql-engine.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

