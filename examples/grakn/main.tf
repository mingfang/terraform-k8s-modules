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

module "scylla-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "scylla"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = var.replicas
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "scylla" {
  source    = "../../modules/scylla"
  name      = "scylla"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.scylla-storage.replicas
  storage       = module.scylla-storage.storage
  storage_class = module.scylla-storage.storage_class_name
}

module "grakn" {
  source    = "../../modules/grakn"
  name      = "grakn"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  cassandra_host = module.scylla.service.metadata[0].name
}