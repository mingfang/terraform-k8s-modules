resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_namespace" "functions" {
  metadata {
    name = "${var.namespace}-functions"
  }
}

module "crd" {
  source = "../../modules/openfaas/crd"
}

module "nats" {
  source    = "../../modules/openfaas/nats"
  name      = "nats"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  cluster_id = "faas-cluster"
}

module "queue-worker" {
  source    = "../../modules/openfaas/queue-worker"
  name      = "queue-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  faas_nats_address      = module.nats.name
  faas_nats_port         = module.nats.service.spec[0].ports[0].port
  faas_nats_cluster_name = module.nats.cluster_id

  faas_gateway_address = module.gateway.name
}

module "prometheus" {
  source    = "../../modules/openfaas/prometheus"
  name      = "prometheus"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  function_namespace = k8s_core_v1_namespace.functions.metadata[0].name
}

module "alertmanager" {
  source    = "../../modules/openfaas/alertmanager"
  name      = "alertmanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  gateway_url = "http://${module.gateway.name}:${module.gateway.service.spec[0].ports[0].port}"
}

module "faas-idler" {
  source    = "../../modules/openfaas/faas-idler"
  name      = "faas-idler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  gateway_url     = "http://${module.gateway.name}:${module.gateway.service.spec[0].ports[0].port}/"
  prometheus_host = module.prometheus.name
  prometheus_port = module.prometheus.service.spec[0].ports[0].port
}

module "faas-netes" {
  source    = "../../modules/openfaas/faas-netes"
  name      = "faas-netes"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  operator           = true
  function_namespace = k8s_core_v1_namespace.functions.metadata[0].name
}

module "gateway" {
  source    = "../../modules/openfaas/gateway"
  name      = "gateway"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  faas_nats_address      = module.nats.name
  faas_nats_port         = module.nats.service.spec[0].ports[0].port
  faas_nats_cluster_name = module.nats.cluster_id

  function_namespace     = k8s_core_v1_namespace.functions.metadata[0].name
  functions_provider_url = "http://${module.faas-netes.name}:${module.faas-netes.service.spec[0].ports[0].port}/"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "gateway" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "openfaas-example.*",
    }
    name      = module.gateway.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.gateway.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.gateway.name
            service_port = module.gateway.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "prometheus" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "openfaas-prometheus-example.*",
    }
    name      = module.prometheus.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.prometheus.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.prometheus.name
            service_port = module.prometheus.service.spec[0].ports[0].port
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
      "nginx.ingress.kubernetes.io/server-alias" = "openfaas-alertmanager-example.*",
    }
    name      = module.alertmanager.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.alertmanager.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.alertmanager.name
            service_port = module.alertmanager.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
