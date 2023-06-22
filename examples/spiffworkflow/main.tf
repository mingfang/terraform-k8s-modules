resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "spiffworkflow-postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "spiffworkflow-data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "cephfs"

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "spiffworkflow-permissions" {
  source    = "../../modules/kubernetes/config-map"
  name      = "spiffworkflow-permissions"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/permissions.yml"
}

module "spiffworkflow-backend" {
  source    = "../../modules/spiffworkflow/backend"
  name      = "spiffworkflow-backend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap            = module.spiffworkflow-permissions.config_map
  configmap_mount_path = "/config"

  pvc            = k8s_core_v1_persistent_volume_claim.data.metadata.0.name
  pvc_mount_path = "/data"

  env_map = {
    SPIFFWORKFLOW_BACKEND_APPLICATION_ROOT         = "/api"
    SPIFFWORKFLOW_BACKEND_PORT                     = "8000"
    SPIFFWORKFLOW_BACKEND_ENV                      = "local_development"
    SPIFFWORKFLOW_BACKEND_RUN_BACKGROUND_SCHEDULER = "true"

    SPIFFWORKFLOW_BACKEND_DATABASE_TYPE     = "postgres"
    SPIFFWORKFLOW_BACKEND_DATABASE_URI      = "postgresql://postgres:postgres@${module.postgres.name}:${module.postgres.ports.0.port}/postgres"
    SPIFFWORKFLOW_BACKEND_UPGRADE_DB        = "true"
    SPIFFWORKFLOW_BACKEND_LOAD_FIXTURE_DATA = "false"

    SPIFFWORKFLOW_BACKEND_OPEN_ID_CLIENT_ID         = "spiffworkflow-example"
    SPIFFWORKFLOW_BACKEND_OPEN_ID_CLIENT_SECRET_KEY = "4d0a2728-4b17-4486-ac95-3b7ad2996557"
    SPIFFWORKFLOW_BACKEND_OPEN_ID_SERVER_URL        = "https://keycloak.rebelsoft.com/auth/realms/spiffworkflow"
    SPIFFWORKFLOW_BACKEND_URL_FOR_FRONTEND          = "https://spiffworkflow-example.rebelsoft.com"
    SPIFFWORKFLOW_BACKEND_URL                       = "https://spiffworkflow-example.rebelsoft.com/api"

    SPIFFWORKFLOW_BACKEND_PERMISSIONS_FILE_ABSOLUTE_PATH = "/config/permissions.yml"
    SPIFFWORKFLOW_BACKEND_BPMN_SPEC_ABSOLUTE_DIR         = "/data"

    FLASK_DEBUG              = "0"
    FLASK_SESSION_SECRET_KEY = "e7711a3ba96c46c68e084a86952de16f"
  }
}

module "spiffworkflow-frontend" {
  source    = "../../modules/spiffworkflow/frontend"
  name      = "spiffworkflow-frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    APPLICATION_ROOT = "/"
    PORT0            = "8001"

    SPIFFWORKFLOW_FRONTEND_RUNTIME_CONFIG_APP_ROUTING_STRATEGY = "path_based"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
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
            service_name = module.spiffworkflow-frontend.name
            service_port = module.spiffworkflow-frontend.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.spiffworkflow-backend.name
            service_port = module.spiffworkflow-backend.ports[0].port
          }
          path = "/api"
        }
      }
    }
  }
}
