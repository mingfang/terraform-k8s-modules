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

module "cassandra-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "cassandra"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.cassandra-storage.replicas
  storage       = module.cassandra-storage.storage
  storage_class = module.cassandra-storage.storage_class_name
}

locals {
  ringpop_seeds = {
    name = "RINGPOP_SEEDS"
    value = join(",", [
      "${var.name}-frontend-0.${var.name}-frontend.${var.namespace}.svc.cluster.local:7933",
      "${var.name}-history-0.${var.name}-history.${var.namespace}.svc.cluster.local:7934",
      "${var.name}-matching-0.${var.name}-matching.${var.namespace}.svc.cluster.local:7935",
      "${var.name}-worker-0.${var.name}-worker.${var.namespace}.svc.cluster.local:7939",
    ])
  }
}

module "cadence-frontend" {
  source    = "../../modules/cadence/server"
  name      = "${var.name}-frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  env       = [local.ringpop_seeds]

  CASSANDRA_SEEDS   = module.cassandra.name
  STATSD_ENDPOINT   = "${module.statsd-exporter.name}:9125"
  SERVICES          = "frontend"
  SKIP_SCHEMA_SETUP = false
}

module "cadence-matching" {
  source    = "../../modules/cadence/server"
  name      = "${var.name}-matching"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  env       = [local.ringpop_seeds]

  CASSANDRA_SEEDS   = module.cassandra.name
  STATSD_ENDPOINT   = "${module.statsd-exporter.name}:9125"
  SERVICES          = "matching"
  SKIP_SCHEMA_SETUP = true
}

module "cadence-history" {
  source    = "../../modules/cadence/server"
  name      = "${var.name}-history"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  env       = [local.ringpop_seeds]

  CASSANDRA_SEEDS   = module.cassandra.name
  STATSD_ENDPOINT   = "${module.statsd-exporter.name}:9125"
  SERVICES          = "history"
  SKIP_SCHEMA_SETUP = true
}

module "cadence-worker" {
  source    = "../../modules/cadence/server"
  name      = "${var.name}-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
  env       = [local.ringpop_seeds]

  CASSANDRA_SEEDS   = module.cassandra.name
  STATSD_ENDPOINT   = "${module.statsd-exporter.name}:9125"
  SERVICES          = "worker"
  SKIP_SCHEMA_SETUP = true
}

module "cadence-web" {
  source    = "../../modules/cadence/web"
  name      = "${var.name}-web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CADENCE_TCHANNEL_PEERS = "${module.cadence-frontend.name}:7933"
}

resource "k8s_extensions_v1beta1_ingress" "cadence-web" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
    }
    name      = module.cadence-web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.cadence-web.name
      http {
        paths {
          backend {
            service_name = module.cadence-web.name
            service_port = 8088
          }
          path = "/"
        }
      }
    }
  }
}

/*
Prometheus
*/

module "prometheus-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "prometheus"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "prometheus" {
  source    = "../../modules/prometheus/prometheus"
  name      = "prometheus"
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

resource "k8s_extensions_v1beta1_ingress" "prometheus" {
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

resource "k8s_extensions_v1beta1_ingress" "alertmanager" {
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
