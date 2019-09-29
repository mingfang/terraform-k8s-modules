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

module "zookeeper-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage            = module.zookeeper-storage.storage
  storage_class = module.zookeeper-storage.storage_class_name
  replicas           = module.zookeeper-storage.replicas
}

module "config" {
  source    = "../../modules/dremio/config"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "master-cordinator-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-master-cordinator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
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

module "master-cordinator" {
  source             = "../../modules/dremio/master-cordinator"
  name               = "${var.name}-master-cordinator"
  namespace          = k8s_core_v1_namespace.this.metadata[0].name
  storage            = module.master-cordinator-storage.storage
  storage_class_name = module.master-cordinator-storage.storage_class_name
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

module "ingress-rules" {
  source    = "../../modules/kubernetes/ingress-rules"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    "nginx.ingress.kubernetes.io/proxy-body-size" = "1024m",
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
              service_name = module.cordinator.service.metadata[0].name
              service_port = module.cordinator.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
  ]
}

module "executor-storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-executor"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "executor" {
  source             = "../../modules/dremio/executor"
  name               = "${var.name}-executor"
  namespace          = k8s_core_v1_namespace.this.metadata[0].name
  replicas           = module.executor-storage.replicas
  storage            = module.executor-storage.storage
  storage_class_name = module.executor-storage.storage_class_name
  config_map         = module.config.config_map
  zookeeper          = "${module.zookeeper.name}:${lookup(module.zookeeper.ports[0], "port")}"
  overrides          = local.overrides
}
