resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

module "loki-rules-ingress" {
  source    = "../../modules/grafana/loki-rule"
  name      = "loki-rules-ingress"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  orgId       = "fake"
  service_key = pagerduty_service_integration.ingress.integration_key
  expr        = <<-EOF
    {job="default/ingress-nginx"} |= " 404 "
  EOF
}

resource "k8s_core_v1_persistent_volume_claim" "rules" {
  metadata {
    name      = "rules"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = var.storage_class_name
  }
}

module "k8s-sidecar" {
  source    = "../../modules/kiwigrid/k8s-sidecar"
  name      = "k8s-sidecar"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_name         = k8s_core_v1_persistent_volume_claim.rules.metadata[0].name
  LABEL            = "loki-rules"
  NAMESPACE        = "ALL"
  UNIQUE_FILENAMES = true
}

module "loki" {
  source    = "../../modules/grafana/loki"
  name      = "loki"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  cassandra        = module.cassandra.name
  alertmanager_url = "http://${module.alertmanager.name}:${module.alertmanager.ports[0].port}"
  pvc_name         = k8s_core_v1_persistent_volume_claim.rules.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "loki" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                         = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"            = "loki-example.*"
      "nginx.ingress.kubernetes.io/enable-access-log"       = "false"
      "nginx.ingress.kubernetes.io/client-body-buffer-size" = "1M"
      "nginx.ingress.kubernetes.io/configuration-snippet"   = <<-EOF
      if ($request_method !~ ^(POST)$) { return 405; }
      EOF
    }
    name      = module.loki.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.loki.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.loki.name
            service_port = module.loki.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "promtail" {
  source    = "../../modules/grafana/promtail"
  name      = "promtail"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  tenant_id = "fake"
  loki_url  = "http://loki-example.rebelsoft.com/loki/api/v1/push"
}

resource "k8s_core_v1_persistent_volume_claim" "grafana" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = var.storage_class_name
  }
}

module "datasource" {
  source    = "../../modules/kubernetes/config-map"
  name      = "datasource"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/datasources.yaml"
}

module "grafana" {
  source    = "../../modules/grafana/grafana"
  name      = "grafana"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_name               = k8s_core_v1_persistent_volume_claim.grafana.metadata[0].name
  datasources_config_map = module.datasource.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "grafana" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "grafana-example.*"
    }
    name      = module.grafana.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.grafana.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.grafana.name
            service_port = module.grafana.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "alertmanager-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "alertmanager-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/alertmanager.yml"
}

module "alertmanager" {
  source    = "../../modules/prometheus/alertmanager"
  name      = "alertmanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "checksum" = module.alertmanager-config.checksum
  }

  config_map = module.alertmanager-config.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "alertmanager" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "alertmanager-example.*"
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
            service_port = module.alertmanager.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}


