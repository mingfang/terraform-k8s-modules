resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  #  S3_ENDPOINT = "http://localstack.localstack-example:4566"
  S3_ENDPOINT = "http://s3-gateway.minio-example:9000"
  BUCKET_NAME = "rebelsoft-neon-example"
}

module "secrets" {
  source    = "../../modules/kubernetes/secret"
  name      = var.namespace
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    AWS_ACCESS_KEY_ID     = base64encode(var.AWS_ACCESS_KEY)
    AWS_SECRET_ACCESS_KEY = base64encode(var.AWS_SECRET_ACCESS_KEY)
  }
}

module "storage_broker" {
  source    = "../../modules/neon/storage-broker"
  name      = "storage-broker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "safekeeper" {
  source    = "../../modules/neon/safekeeper"
  name      = "safekeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  env_from        = [module.secrets.secret_ref]
  BROKER_ENDPOINT = "http://${module.storage_broker.name}:${module.storage_broker.ports.0.port}"
  S3_ENDPOINT     = local.S3_ENDPOINT
  BUCKET_NAME     = local.BUCKET_NAME
}

module "pageserver" {
  source    = "../../modules/neon/pageserver"
  name      = "pageserver"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_from        = [module.secrets.secret_ref]
  BROKER_ENDPOINT = "http://${module.storage_broker.name}:${module.storage_broker.ports.0.port}"
  S3_ENDPOINT     = local.S3_ENDPOINT
  BUCKET_NAME     = local.BUCKET_NAME
}

module "compute_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "compute"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
  from-map = {
    "spec.json" = templatefile("${path.module}/config/spec.json", {
      CLUSTER_ID   = var.namespace
      CLUSTER_NAME = var.namespace
      TENANT_ID    = "ca5fbf3053bc9ea10eb2f32949f78c91"
      TIMELINE_ID  = "80ed3be9cbb1a738d90ff39e7e4ccaaa"
      SHARED_PRELOAD_LIBRARIES = "pg_stat_statements"
    })
  }
}

module "compute" {
  source    = "../../modules/neon/compute"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  image = "registry.rebelsoft.com/compute-node-v15:latest"

  env_map = {
    PGPASSWORD        = "cloud_admin"
    POSTGRES_PASSWORD = "postgres"
  }
  configmap = module.compute_config.config_map

  command = [
    "bash",
    "-c",
    <<-EOF
    compute_ctl \
    --pgdata /var/db/postgres/compute \
    -C "postgresql://cloud_admin@localhost:5432/postgres"  \
    -b /usr/local/bin/postgres \
    -S /config/spec.json
    EOF
  ]
}

module "postgres_init_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/init"
}

module "postgres_init" {
  source    = "../../modules/kubernetes/job"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "postgres:15.1"

  env_map = {
    PGHOST            = module.compute.name
    PGPORT            = module.compute.ports.0.port
    PGUSER            = "cloud_admin"
    PGPASSWORD        = "cloud_admin"
    PGDATABASE        = "postgres"
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

module "wsproxy" {
  source    = "../../modules/neon/wsproxy"
  name = "wsproxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    ALLOW_ADDR_REGEX="${module.compute.name}.${var.namespace}"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "wsproxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "wsproxy-${var.namespace}.*"
    }
    name      = "wsproxy-${var.namespace}"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "wsproxy-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.wsproxy.name
            service_port = module.wsproxy.ports.0.port
          }
          path = "/"
        }
      }
    }
  }
}

