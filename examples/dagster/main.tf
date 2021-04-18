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

  POSTGRES_DB       = "dagster"
  POSTGRES_USER     = "dagster"
  POSTGRES_PASSWORD = "dagster"
}

module "postgres_password" {
  source    = "../../modules/kubernetes/secret"
  name      = "postgres-password"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "postgresql-password" = base64encode("dagster")
  }
}

locals {
  env = [
    {
      name = "DAGSTER_PG_PASSWORD"
      value_from = {
        secret_key_ref = {
          key  = "postgresql-password"
          name = module.postgres_password.name
        }
      }
    },
  ]
}


module "rbac" {
  source    = "../../modules/dagster/rbac"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "dagster-daemon" {
  source    = "../../modules/dagster/dagster-daemon"
  name      = "dagster-daemon"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  service_account_name = module.rbac.name
  config_map           = module.config_map_instance.name
  env                  = local.env
  config_map_env       = module.config_map_pipeline.name
}

module "example-user-code" {
  source    = "../../modules/dagster/example-user-code"
  name      = "example-user-code"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
}

module "dagit" {
  source    = "../../modules/dagster/dagit"
  name      = "dagit"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  service_account_name = module.rbac.name
  config_map           = module.config_map_instance.name
  env                  = local.env
  config_map_env       = module.config_map_pipeline.name
  config_map_workspace = module.config_map_workspace.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "dagit" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dagster-example.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = module.dagit.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.dagit.name}.${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.dagit.name
            service_port = module.dagit.ports[0].port
          }
        }
      }
    }
  }
}

