resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 2
  storage       = "1Gi"
  storage_class = "cephfs"

  CASSANDRA_DC = "dc1"
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "quine.conf" = templatefile("${path.module}/quine.conf", {
      cassandra_endpoint         = "${module.cassandra.name}:${module.cassandra.ports[0].port}"
      cassandra_local_datacenter = "dc1"
    })
  }
}

module "quine" {
  source    = "../../modules/quine"
  name      = "quine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config-checksum" = module.config.checksum
  }
  replicas = 1

  configmap = module.config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.quine.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.quine.name
            service_port = module.quine.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
