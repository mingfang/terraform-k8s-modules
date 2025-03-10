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

module "prometheus-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = var.replicas
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "prometheus" {
  source    = "../../modules/prometheus/prometheus"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.prometheus-storage.replicas
  storage       = module.prometheus-storage.storage
  storage_class = module.prometheus-storage.storage_class_name
}

module "alertmanager" {
  source    = "../../modules/prometheus/alertmanager"
  name      = "alertmanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "statsd-exporter" {
  source    = "../../modules/prometheus/statsd-exporter"
  name      = "statsd-exporter"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "prometheus" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "prometheus.*"
    }
    name      = module.prometheus.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.prometheus.name
      http {
        paths {
          backend {
            service_name = module.prometheus.name
            service_port = 9090
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "alertmanager" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "alertmanager.*"
    }
    name      = module.alertmanager.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.alertmanager.name
      http {
        paths {
          backend {
            service_name = module.alertmanager.name
            service_port = 9093
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "statsd-exporter" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "statsd-exporter.*"
    }
    name      = module.statsd-exporter.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.statsd-exporter.name
      http {
        paths {
          backend {
            service_name = module.statsd-exporter.name
            service_port = 9102
          }
          path = "/"
        }
      }
    }
  }
}
