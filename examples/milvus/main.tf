resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "etcd" {
  source    = "../../modules/etcd"
  name      = "etcd"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  storage_class = "cephfs"
  storage       = "1Gi"
}

module "pulsar" {
  source    = "../../modules/pulsar-standalone"
  name      = "pulsar"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
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

module "rootcoord" {
  source    = "../../modules/milvus/rootcoord"
  name      = "rootcoord"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "querycoord" {
  source    = "../../modules/milvus/querycoord"
  name      = "querycoord"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "querynode" {
  source    = "../../modules/milvus/querynode"
  name      = "querynode"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "indexcoord" {
  source    = "../../modules/milvus/indexcoord"
  name      = "indexcoord"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "indexnode" {
  source    = "../../modules/milvus/indexnode"
  name      = "indexnode"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  ETCD_ENDPOINTS      = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS       = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY    = var.minio_access_key
  MINIO_SECRET_KEY    = var.minio_secret_key
  PULSAR_ADDRESS      = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
  INDEX_COORD_ADDRESS = "${module.indexcoord.name}:${module.indexcoord.ports[0].port}"
}

module "datacoord" {
  source    = "../../modules/milvus/datacoord"
  name      = "datacoord"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "datanode" {
  source    = "../../modules/milvus/datanode"
  name      = "datanode"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "proxy" {
  source    = "../../modules/milvus/proxy"
  name      = "proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ETCD_ENDPOINTS   = "${module.etcd.name}:${module.etcd.ports[0].port}"
  MINIO_ADDRESS    = "${module.minio.name}:${module.minio.ports[0].port}"
  MINIO_ACCESS_KEY = var.minio_access_key
  MINIO_SECRET_KEY = var.minio_secret_key
  PULSAR_ADDRESS   = "pulsar://${module.pulsar.name}:${module.pulsar.ports[1].port}"
}

module "attu" {
  source    = "../../modules/milvus/attu"
  name      = "attu"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  HOST_URL   = "//${var.namespace}.rebelsoft.com"
  MILVUS_URL = "${module.proxy.name}:${module.proxy.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "attu" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.attu.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.attu.name
            service_port = module.attu.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

