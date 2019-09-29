variable "name" {
  default = "spark"
}

variable "namespace" {
  default = "spark"
}

variable "ingress_ip" {
  default = "192.168.2.146"
}

variable "ingress_node_port" {
  default = "30080"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = { "storage" = "5Gi" }
    }

    storage_class_name = "alluxio"
  }
}


locals {
  overrides = {
    annotations = {
      "pvc" = k8s_core_v1_persistent_volume_claim.this.metadata[0].resource_version
    }
    volume_mounts = [
      {
        name       = "alluxio-fuse-mount"
        mount_path = "/alluxio"
      }
    ]
    volumes = [
      {
        name = "alluxio-fuse-mount"
        persistent_volume_claim = {
          claim_name = k8s_core_v1_persistent_volume_claim.this.metadata[0].name
        }
      }
    ]
  }
}

module "master" {
  source    = "../../modules/spark/master"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "worker" {
  source     = "../../modules/spark/worker"
  name       = "${var.name}-worker"
  namespace  = k8s_core_v1_namespace.this.metadata[0].name
  master_url = module.master.master_url
  overrides  = local.overrides
}

module "ui-proxy" {
  source      = "../../modules/spark/ui-proxy"
  name        = "${var.name}-ui-proxy"
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  master_host = module.master.service.metadata[0].name
  master_port = module.master.service.spec[0].ports[1].port
}

module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
  }
  ingress_class = "nginx"
  rules = [
    {
      host = var.name

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.ui-proxy.service.metadata[0].name
              service_port = module.ui-proxy.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
  ]
}