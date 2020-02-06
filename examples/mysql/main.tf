resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "mysql-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "mysql" {
  source        = "../../modules/mysql"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.mysql-storage.storage_class_name
  storage       = module.mysql-storage.storage
  replicas      = module.mysql-storage.replicas

  MYSQL_USER          = "mysql"
  MYSQL_PASSWORD      = "mysql"
  MYSQL_ROOT_PASSWORD = "mysql"
  MYSQL_DATABASE      = "mysql"
}
