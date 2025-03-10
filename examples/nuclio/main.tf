resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "registry" {
  metadata {
    name      = "registry"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "registry" {
  source    = "../../modules/docker-registry"
  name      = "registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc_name  = k8s_core_v1_persistent_volume_claim.registry.metadata[0].name
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "platform.yaml" = <<-EOF
    scaleToZero:
      mode: enabled
      inactivityWindowPresets:
        - 1m
        - 2m
        - 5m
        - 10m
        - 30m
      scaleResources:
        - metricName: cpu
          windowSize: "1m"
          threshold: 5
    logger:
      sinks:
        myStdoutLoggerSink:
          kind: stdout
      system:
        - level: debug
          sink: myStdoutLoggerSink
      functions:
        - level: debug
          sink: myStdoutLoggerSink
    EOF
  }
}

module "controller" {
  source    = "../../modules/nuclio/controller"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap = module.config.config_map
}

module "dashboard" {
  source    = "../../modules/nuclio/dashboard"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap            = module.config.config_map
  service_account_name = module.controller.service_account

  NUCLIO_DASHBOARD_REGISTRY_URL        = "${module.registry.name}.${var.namespace}:${module.registry.ports[0].port}"
  NUCLIO_DASHBOARD_RUN_REGISTRY_URL    = "${var.namespace}-registry.rebelsoft.com"
  NUCLIO_KANIKO_INSECURE_PUSH_REGISTRY = "true"
}

module "autoscaler" {
  source    = "../../modules/nuclio/autoscaler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap            = module.config.config_map
  service_account_name = module.controller.service_account
}

module "dlx" {
  source    = "../../modules/generic-deployment-service"
  name      = "dlx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "quay.io/nuclio/dlx:1.1.11-amd64"

  service_account_name = module.controller.service_account

  configmap            = module.config.config_map
  configmap_mount_path = "/etc/nuclio/config/platform"

  env_map = {
    NUCLIO_RESOURCESCALER_FUNCTION_READINESS_VERIFICATION_ENABLED = "true"
    NUCLIO_SCALER_NAMESPACE                                       = var.namespace
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "dashboard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.dashboard.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.dashboard.name
            service_port = module.dashboard.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-registry.*"
    }
    name      = module.registry.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-registry"
      http {
        paths {
          backend {
            service_name = module.registry.name
            service_port = module.registry.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "priority-class-igz-workload-medium" {
  source      = "../../modules/kubernetes/priority-class"
  name        = "igz-workload-medium"
  value       = 50
  description = "igz-workload-medium"
}
