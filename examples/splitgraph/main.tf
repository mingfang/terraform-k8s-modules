resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "splitgraph" {
  source        = "../../modules/splitgraph"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "splitgraph"
  POSTGRES_PASSWORD = "splitgraph"
  POSTGRES_DB       = "splitgraph"

  SG_S3_HOST   = "${module.minio.name}.${var.namespace}"
  SG_S3_PORT   = module.minio.ports[0].port
  SG_S3_KEY    = var.minio_access_key
  SG_S3_PWD    = var.minio_secret_key
  SG_S3_BUCKET = "splitgraph"

  sgconfig = module.sgconfig.name

  image = "splitgraph/engine:0.3.9-postgis"
}

module "sgconfig" {
  source    = "../../modules/kubernetes/config-map"
  name      = "sgconfig"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/sgconfig"
}

// pgadmin
resource "k8s_core_v1_persistent_volume_claim" "pgadmin" {
  metadata {
    name      = "pgadmin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "pgadmin" {
  source    = "../../modules/pgadmin"
  name      = "pgadmin"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_name                 = k8s_core_v1_persistent_volume_claim.pgadmin.metadata[0].name
  PGADMIN_DEFAULT_EMAIL    = "splitgraph@example.com"
  PGADMIN_DEFAULT_PASSWORD = "splitgraph"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "pgadmin" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-pgadmin.*"
    }
    name      = module.pgadmin.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-pgadmin"
      http {
        paths {
          backend {
            service_name = module.pgadmin.name
            service_port = module.pgadmin.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

// metabase
/*
module "metabase" {
  source    = "../../modules/metabase"
  name      = "metabase"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = [
    {
      name  = "MB_DB_TYPE"
      value = "postgres"
    },
    {
      name  = "MB_DB_HOST"
      value = module.splitgraph.name
    },
    {
      name  = "MB_DB_PORT"
      value = module.splitgraph.ports[0].port
    },
    {
      name  = "MB_DB_DBNAME"
      value = "postgres"
    },
    {
      name  = "MB_DB_USER"
      value = "splitgraph"
    },
    {
      name  = "MB_DB_PASS"
      value = "splitgraph"
    },
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "metabase" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-metabase.*"
    }
    name      = module.metabase.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-metabase"
      http {
        paths {
          backend {
            service_name = module.metabase.name
            service_port = module.metabase.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
*/

// minio
module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = [
    "splitgraph"
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio.*"
    }
    name      = module.minio.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-minio"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio-console" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio-console.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "${module.minio.name}-console"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-minio-console"
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
