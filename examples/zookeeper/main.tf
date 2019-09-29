resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "zookeeper-storage" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = var.replicas
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = module.zookeeper-storage.replicas
  storage            = module.zookeeper-storage.storage
  storage_class_name = module.zookeeper-storage.storage_class_name
}