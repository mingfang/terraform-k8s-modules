terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.storage_class_name

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "casc_configs" {
  source    = "../../modules/kubernetes/config-map"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/casc_configs"
}

module "jenkins" {
  source    = "../../modules/jenkins/jenkins"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  resources = {
    requests = {
      cpu    = "500m"
      memory = "500Mi"
    }
    limits = {
      memory = "2Gi"
    }
  }

  casc_config_map_name = module.casc_configs.name
  pvc_name             = k8s_core_v1_persistent_volume_claim.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "jenkins-example.*"
    }
    name      = module.jenkins.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.jenkins.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.jenkins.name
            service_port = module.jenkins.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
