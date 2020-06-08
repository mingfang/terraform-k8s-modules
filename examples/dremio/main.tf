resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage       = "1Gi"
  storage_class = "cephfs"
  replicas      = 3
}

module "config" {
  source    = "../../modules/dremio/config"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

// optional Alluxio integration

locals {
  /*
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
*/
  overrides = {}
}

module "master-cordinator" {
  source             = "../../modules/dremio/master-cordinator"
  name               = "${var.name}-master-cordinator"
  namespace          = k8s_core_v1_namespace.this.metadata[0].name
  storage            = "1Gi"
  storage_class_name = "cephfs"
  config_map         = module.config.config_map
  zookeeper          = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
  overrides          = local.overrides
}

module "cordinator" {
  source            = "../../modules/dremio/cordinator"
  name              = "${var.name}-cordinator"
  namespace         = k8s_core_v1_namespace.this.metadata[0].name
  replicas          = 2
  config_map        = module.config.config_map
  master-cordinator = module.master-cordinator.service.metadata[0].name
  zookeeper         = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
  overrides         = local.overrides
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "1024m" // for large file uploads
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = "${var.name}.${var.namespace}.rebelsoft.com"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.cordinator.name
            service_port = module.cordinator.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "${var.name}.${var.namespace}.rebelsoft.com"
      ]
      secret_name = "${var.name}.${var.namespace}.rebelsoft.com-tls"
    }
  }
}


module "executor" {
  source             = "../../modules/dremio/executor"
  name               = "${var.name}-executor"
  namespace          = k8s_core_v1_namespace.this.metadata[0].name
  replicas           = 3
  storage            = "1Gi"
  storage_class_name = "cephfs"
  config_map         = module.config.config_map
  zookeeper          = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
  overrides          = local.overrides
}
