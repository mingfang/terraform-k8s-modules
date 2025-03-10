resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redpanda" {
  source    = "../../modules/redpanda"
  name      = "redpanda"
  namespace = var.namespace

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 4

  args = join(" ", [
    "--set redpanda.enable_transactions=true",
    "--set redpanda.enable_idempotence=true",
    "--set redpanda.auto_create_topics_enabled=true",
  ])
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "redpanda" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.redpanda.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          path = "/"
          backend {
            service_name = module.redpanda.name
            service_port = module.redpanda.ports[0].port
          }
        }
      }
    }
  }
}

module "kowl_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "kowl"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "config.yml" = <<-EOF
    kafka:
      brokers: ["${module.redpanda.name}:${module.redpanda.ports[1].port}"]
      schemaRegistry:
        enabled: true
        urls: ["http://${module.redpanda.name}:${module.redpanda.ports[2].port}"]
    EOF
  }
}

module "kowl" {
  source    = "../../modules/kowl"
  name      = "kowl"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  configmap = module.kowl_config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "kowl" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "kowl-${var.namespace}.*"
    }
    name      = module.kowl.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "kowl-${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.kowl.name
            service_port = module.kowl.ports[0].port
          }
        }
      }
    }
  }
}
