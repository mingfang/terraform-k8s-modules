module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# DAGU distributed configuration
resource "k8s_core_v1_config_map" "dagu_config" {
  metadata {
    name      = "dagu-config"
    namespace = module.namespace.name
  }

  data = {
    "dagu.yaml" = <<-EOT
    coordinator:
      advertise: "dagu-coordinator:50055"
    worker:
      max_concurrent_jobs: 4
    scheduler:
      max_jobs_to_schedule: 10
    log:
      level: "info"
      format: "text"
      max_files: 5
    EOT
  }
}

# Shared persistent volume for DAG definitions and data
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data-volume"
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

# UI — main web interface (port 8080)
module "dagu" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { http = 8080 }

  env_map = {
    DAGU_CONFIG_PATH   = "/etc/dagu/dagu.yaml"
    DAGU_LOG_LEVEL     = "info"
    DAGU_LOG_FORMAT    = "text"
    DAGU_MAX_LOG_FILES = "5"
  }

  pvcs = [{
    name       = "data-volume"
    mount_path = "/data"
  }]

  configmap = k8s_core_v1_config_map.dagu_config
}

# Scheduler — manages job execution (port 8090)
module "dagu-scheduler" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu-scheduler"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { http = 8090 }

  command = ["dagu"]
  args    = ["scheduler"]

  env_map = {
    DAGU_CONFIG_PATH   = "/etc/dagu/dagu.yaml"
    DAGU_LOG_LEVEL     = "info"
    DAGU_LOG_FORMAT    = "text"
    DAGU_MAX_LOG_FILES = "5"
  }

  pvcs = [{
    name       = "data-volume"
    mount_path = "/data"
  }]

  configmap = k8s_core_v1_config_map.dagu_config
}

# Coordinator — cluster-wide coordination (ports 50055, 8091)
module "dagu-coordinator" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu-coordinator"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { grpc = 50055, health = 8091 }

  command = ["dagu"]
  args    = ["coordinator"]

  env_map = {
    DAGU_CONFIG_PATH             = "/etc/dagu/dagu.yaml"
    DAGU_COORDINATOR_ADVERTISE   = "dagu-coordinator:50055"
    DAGU_LOG_LEVEL               = "info"
    DAGU_LOG_FORMAT              = "text"
    DAGU_MAX_LOG_FILES           = "5"
  }

  pvcs = [{
    name       = "data-volume"
    mount_path = "/data"
  }]

  configmap = k8s_core_v1_config_map.dagu_config
}

# Worker — executes DAGs (port 8092, 2 replicas)
module "dagu-worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu-worker"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { health = 8092 }
  replicas  = 2

  command = ["dagu"]
  args    = ["worker"]

  env = [{
    name  = "DAGU_CONFIG_PATH"
    value = "/etc/dagu/dagu.yaml"
  }, {
    name = "DAGU_WORKER_ID"
    value_from = {
      field_ref = {
        field_path = "metadata.name"
      }
    }
  }, {
    name  = "DAGU_LOG_LEVEL"
    value = "info"
  }, {
    name  = "DAGU_LOG_FORMAT"
    value = "text"
  }, {
    name  = "DAGU_MAX_LOG_FILES"
    value = "5"
  }]

  pvcs = [{
    name       = "data-volume"
    mount_path = "/data"
  }]

  configmap = k8s_core_v1_config_map.dagu_config
}

# Ingress — exposes the DAGU web UI
resource "k8s_networking_k8s_io_v1_ingress" "app" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-app"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.dagu.name
              port {
                number = module.dagu.ports_map.http
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
