resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  image     = "postgres:16"

  storage_class = "cephfs"
  storage       = "1Gi"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
  ]

  env_map = {
    POSTGRES_USER        = "postgres"
    POSTGRES_PASSWORD    = "postgres"
    POSTGRES_DB          = "postgres"
    POSTGRES_INITDB_ARGS = "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
  }
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
  from-map = {
    "homeserver.yaml" = templatefile("${path.module}/config/homeserver.yaml", {
      issuer = var.issuer,
      client_id = var.client_id,
      client_secret = var.client_secret,
    }),
    "log.config" = templatefile("${path.module}/config/log.config", {
      level = "INFO"
    }),
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}


module "synapse" {
  source    = "../../modules/synapse"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap            = module.config.config_map
  configmap_mount_path = "/config"

  pvc            = k8s_core_v1_persistent_volume_claim.data.metadata.0.name
  pvc_mount_path = "/data"

  env_map = {
    SYNAPSE_CONFIG_PATH = "/config/homeserver.yaml"
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
            service_name = module.synapse.name
            service_port = module.synapse.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
