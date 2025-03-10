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

module "minio" {
  source    = "../../modules/minio"
  name      = "minio"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = "risingwave"
  minio_secret_key = "risingwave"

  create_buckets = ["hummock001"]
}

module "meta-node" {
  source    = "../../modules/risingwave"
  name      = "meta-node"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ports = [
    { name = "tcp", port = 5690 },
    { name = "dashboard", port = 5691 },
    { name = "rpc", port = 50051 },
    { name = "prometheus", port = 1250 },
  ]

  command = [
    "/risingwave/bin/risingwave",
    "meta-node",
  ]

  env_map = {
    RW_LISTEN_ADDR            = "0.0.0.0:5690"
    RW_ADVERTISE_ADDR         = "meta-node:5690"
    RW_DASHBOARD_HOST         = "0.0.0.0:5691"
    RW_PROMETHEUS_HOST        = "0.0.0.0:1250"
    RW_CONNECTOR_RPC_ENDPOINT = "0.0.0.0:50051"

    RW_META_ADDR      = "http://meta-node:5690"
    RW_BACKEND        = "etcd"
    RW_ETCD_ENDPOINTS = "${module.etcd.name}:${module.etcd.ports[0].port}"
    RW_STATE_STORE    = "hummock+minio://risingwave:risingwave@${module.minio.name}:${module.minio.ports[0].port}/hummock001"
    RW_DATA_DIRECTORY = "hummock_001"
  }
}

module "frontend" {
  source    = "../../modules/risingwave"
  name      = "frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ports = [
    { name = "tcp", port = 4566 },
    { name = "health", port = 6786 },
    { name = "prometheus", port = 2222 },
  ]

  command = [
    "/risingwave/bin/risingwave",
    "frontend",
  ]

  env_map = {
    RW_LISTEN_ADDR                = "0.0.0.0:4566"
    RW_ADVERTISE_ADDR             = "frontend:4566"
    RW_PROMETHEUS_HOST            = "0.0.0.0:2222"
    RW_HEALTH_CHECK_LISTENER_ADDR = "0.0.0.0:6786"

    RW_META_ADDR = "http://${module.meta-node.name}:${module.meta-node.ports[0].port}"
  }
}

module "compute-node" {
  source    = "../../modules/risingwave"
  name      = "compute-node"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  ports = [
    { name = "tcp", port = 5688 },
    { name = "rpc", port = 50051 },
    { name = "prometheus", port = 1222 },
  ]

  command = [
    "/risingwave/bin/risingwave",
    "compute-node",
  ]

  env_map = {
    RW_LISTEN_ADDR            = "0.0.0.0:5688"
    RW_ADVERTISE_ADDR         = "$(POD_NAME).compute-node:5688"
    RW_PROMETHEUS_HOST        = "0.0.0.0:1222"
    RW_CONNECTOR_RPC_ENDPOINT = "0.0.0.0:50051"
    RW_ASYNC_STACK_TRACE      = "verbose"
    RW_PARALLELISM            = "4"
    RW_TOTAL_MEMORY_BYTES     = "8589934592"
    RW_ROLE                   = "both"

    RW_META_ADDR = "http://${module.meta-node.name}:${module.meta-node.ports[0].port}"
  }
}

module "compactor-node" {
  source    = "../../modules/risingwave"
  name      = "compactor-node"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ports = [
    { name = "tcp", port = 6660 },
    { name = "prometheus", port = 1260 },
  ]

  command = [
    "/risingwave/bin/risingwave",
    "compactor-node",
  ]

  env_map = {
    RW_LISTEN_ADDR     = "0.0.0.0:6660"
    RW_ADVERTISE_ADDR  = "$(POD_NAME).compactor:6660"
    RW_PROMETHEUS_HOST = "0.0.0.0:1260"

    RW_META_ADDR = "http://${module.meta-node.name}:${module.meta-node.ports[0].port}"
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
            service_name = module.meta-node.name
            service_port = module.meta-node.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
