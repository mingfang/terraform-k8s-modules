resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

/* Minio for tier-2 storage */

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  create_buckets = ["pravega"]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "minio" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}-minio.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = "minio"
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

/* Bookeeper for tier-1 storage */

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "bookkeeper" {
  source    = "../../modules/pravega/bookkeeper"
  name      = "bookkeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  storage       = "1Gi"
  storage_class = "cephfs"

  ZK_URL = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
}

/* Pravega */

module "controller" {
  source    = "../../modules/pravega/controller"
  name      = "controller"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  ZK_URL          = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
  SERVICE_HOST_IP = "segmentstore"
}

module "segmentstore" {
  source    = "../../modules/pravega/segmentstore"
  name      = "segmentstore"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  ZK_URL         = "${module.zookeeper.name}:${module.zookeeper.ports[0].port}"
  CONTROLLER_URL = "tcp://${module.controller.name}:${module.controller.ports[0].port}"

  env_map = {
    TIER2_STORAGE = "S3"
    #    TIER2_STORAGE= "HDFS"
    #    HDFS_REPLICATION=1
    #    HDFS_URL="hdfs://${module.hdfs.name}:8020"
  }

  JAVA_OPTS = <<-EOF
  -Dpravegaservice.storage.layout="CHUNKED_STORAGE"
  -Dpravegaservice.storage.impl.name="S3"
  -Ds3.bucket=pravega
  -Ds3.prefix=""
  -Ds3.connect.config.uri.override="true"
  -Ds3.connect.config.uri=http://${module.minio.name}:${module.minio.ports[0].port}
  -Ds3.connect.config.access.key=${var.minio_access_key}
  -Ds3.connect.config.secret.key=${var.minio_secret_key}
  EOF
}

/* Pravega REST endpoint */

resource "k8s_networking_k8s_io_v1beta1_ingress" "pravega" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.controller.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.controller.name
            service_port = module.controller.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

