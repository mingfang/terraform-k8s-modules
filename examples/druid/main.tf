resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  POSTGRES_USER     = "druid"
  POSTGRES_PASSWORD = "druid"
  POSTGRES_DB       = "druid"
}

locals {
  env = [
    {
      name  = "druid_storage_type"
      value = "s3"
    },
    {
      name  = "druid_storage_bucket"
      value = "druid"
    },
    {
      name  = "druid_storage_baseKey"
      value = "druid/segments"
    },
    {
      name  = "druid_indexer_logs_type"
      value = "s3"
    },
    {
      name  = "druid_indexer_logs_s3Bucket"
      value = "druid"
    },
    {
      name  = "druid_indexer_logs_s3Prefix"
      value = "druid/indexing-logs"
    },
    {
      name  = "druid_s3_accessKey"
      value = var.minio_access_key
    },
    {
      name  = "druid_s3_secretKey"
      value = var.minio_secret_key
    },
    {
      name  = "druid_s3_enablePathStyleAccess"
      value = "true"
    },
    {
      name  = "druid_s3_endpoint_url"
      value = "http://${module.minio.name}:${module.minio.ports[0].port}/"
    },
  ]
  loadList = [
    "druid-avro-extensions",
    "druid-bloom-filter",
    "druid-datasketches",
    "druid-lookups-cached-global",
    "druid-kafka-indexing-service",
    "druid-parquet-extensions",
    "druid-protobuf-extensions",
    "druid-s3-extensions",
    "druid-stats",
    "postgresql-metadata-storage",
  ]
}

module "coordinator" {
  source    = "../../modules/druid/coordinator"
  name      = "coordinator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  druid_zk_service_host                       = module.zookeeper.name
  druid_extensions_loadList                   = local.loadList
  druid_metadata_storage_type                 = "postgresql"
  druid_metadata_storage_connector_connectURI = "jdbc:postgresql://${module.postgres.name}/druid"
  druid_metadata_storage_connector_user       = "druid"
  druid_metadata_storage_connector_password   = "druid"

  env = local.env
}

module "broker" {
  source    = "../../modules/druid/broker"
  name      = "broker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  druid_zk_service_host                       = module.zookeeper.name
  druid_extensions_loadList                   = local.loadList
  druid_metadata_storage_type                 = "postgresql"
  druid_metadata_storage_connector_connectURI = "jdbc:postgresql://${module.postgres.name}/druid"
  druid_metadata_storage_connector_user       = "druid"
  druid_metadata_storage_connector_password   = "druid"
  env                                         = local.env

  resources = {
    requests = {
      cpu    = "500m"
      memory = "8Gi"
    }
  }
}

module "historical" {
  source    = "../../modules/druid/historical"
  name      = "historical"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  druid_zk_service_host                       = module.zookeeper.name
  druid_extensions_loadList                   = local.loadList
  druid_metadata_storage_type                 = "postgresql"
  druid_metadata_storage_connector_connectURI = "jdbc:postgresql://${module.postgres.name}/druid"
  druid_metadata_storage_connector_user       = "druid"
  druid_metadata_storage_connector_password   = "druid"

  env           = local.env
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "middlemanager" {
  source    = "../../modules/druid/middlemanager"
  name      = "middlemanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  druid_zk_service_host                       = module.zookeeper.name
  druid_extensions_loadList                   = local.loadList
  druid_metadata_storage_type                 = "postgresql"
  druid_metadata_storage_connector_connectURI = "jdbc:postgresql://${module.postgres.name}/druid"
  druid_metadata_storage_connector_user       = "druid"
  druid_metadata_storage_connector_password   = "druid"

  env           = local.env
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "router" {
  source    = "../../modules/druid/router"
  name      = "router"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  druid_zk_service_host                       = module.zookeeper.name
  druid_extensions_loadList                   = local.loadList
  druid_metadata_storage_type                 = "postgresql"
  druid_metadata_storage_connector_connectURI = "jdbc:postgresql://${module.postgres.name}/druid"
  druid_metadata_storage_connector_user       = "druid"
  druid_metadata_storage_connector_password   = "druid"
  env                                         = local.env
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "router" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "druid-example.*"
    }
    name      = module.router.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}-router"
      http {
        paths {
          backend {
            service_name = module.router.name
            service_port = module.router.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "nginx.ingress.kubernetes.io/server-alias"    = "druid-example-minio.*"
    }
    name      = module.minio.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}-minio"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

