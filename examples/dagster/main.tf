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
      name  = "DAGSTER_PG_HOST"
      value = module.postgres.name
    },
    {
      name  = "DAGSTER_PG_PORT"
      value = 5432
    },
    {
      name  = "DAGSTER_PG_DB"
      value = "dagster"
    },
    {
      name  = "DAGSTER_PG_USER"
      value = "dagster"
    },
    {
      name       = "DAGSTER_PG_PASSWORD"
      value_from = {
        secret_key_ref = {
          key  = "postgresql-password"
          name = module.postgres_password.name
        }
      }
    },
    {
      name  = "DAGSTER_K8S_PG_PASSWORD_SECRET"
      value = module.postgres_password.name
    },
    {
      name  = "DAGSTER_K8S_JOB_CONFIG_MAP"
      value = module.config_map_job.name
    },
    {
      name  = "DAGSTER_K8S_JOB_ENV_CONFIGMAP"
      value = module.config_map_job_env.name
    },
    {
      name  = "DAGSTER_K8S_JOB_NAMESPACE"
      value = var.namespace
    },
    {
      name  = "DAGSTER_K8S_JOB_SERVICE_ACCOUNT"
      value = "default"
    }
  ]
}

module "dagster-daemon" {
  source      = "../../modules/dagster/dagster-daemon"
  name        = "dagster-daemon"
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "dagster-checksum"   = module.config_map_dagster.checksum
    "workspace-checksum" = module.config_map_workspace.checksum
  }

  env                  = local.env
  config_map_dagster   = module.config_map_dagster.name
  config_map_workspace = module.config_map_workspace.name
}


module "dagit" {
  source      = "../../modules/dagster/dagit"
  name        = "dagit"
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "dagster-checksum"   = module.config_map_dagster.checksum
    "workspace-checksum" = module.config_map_workspace.checksum
  }

  env                  = local.env
  config_map_dagster   = module.config_map_dagster.name
  config_map_workspace = module.config_map_workspace.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "dagit" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
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

