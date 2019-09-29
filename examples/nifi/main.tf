resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "zookeeper-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "10Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zookeeper" {
  source        = "../../modules/zookeeper"
  name          = "zookeeper"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = module.zookeeper-storage.replicas
  storage       = module.zookeeper-storage.storage
  storage_class = module.zookeeper-storage.storage_class_name
}

module "nifi" {
  source    = "../../modules/nifi/nifi"
  name      = var.name
  namespace = var.namespace
  ports = [
    {
      name = "http"
      port = 80
    }
  ]
  replicas = 3
  env = [
    {
      name  = "NIFI_ZK_CONNECT_STRING"
      value = "${module.zookeeper.name}:2181"
    },
    {
      name  = "NIFI_CLUSTER_IS_NODE"
      value = "true"
    },
    {
      name  = "NIFI_REMOTE_INPUT_HOST"
      value = "nifi.192.168.2.245.nip.io"
    },
  ]
}

module "minifi-c2" {
  source            = "../../modules/nifi/minifi-c2"
  name              = "minifi-c2"
  namespace         = var.namespace
  NIFI_REST_API_URL = "http://${module.nifi.name}:${module.nifi.service.spec[0].ports[0].port}/nifi-api"
}

// be sure to avoid load_balancer_ip conflict
module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = "${var.name}-ingress"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = "${var.name}-ingress"
  load_balancer_ip = "192.168.2.245"
  service_type     = "LoadBalancer"
}

resource "k8s_extensions_v1beta1_ingress" "nifi" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = module.ingress.ingress_class
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.name}.*",
      "nginx.ingress.kubernetes.io/proxy-body-size" = "11024m",
      //      "nginx.ingress.kubernetes.io/upstream-hash-by": "$remote_addr",
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.name
      http {
        paths {
          backend {
            service_name = module.nifi.name
            service_port = module.nifi.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_extensions_v1beta1_ingress" "minifi-c2" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
      "nginx.ingress.kubernetes.io/server-alias" = "minifi-c2.*",
    }
    name      = "minifi-c2"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "minifi-c2"
      http {
        paths {
          backend {
            service_name = module.minifi-c2.name
            service_port = module.minifi-c2.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}