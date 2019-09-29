
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

module "minecraft-storage" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name          = "${var.name}"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "minecraft" {
  source    = "../../modules/minecraft"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage            = module.minecraft-storage.storage
  storage_class_name = module.minecraft-storage.storage_class_name

  bungeecord = true
}

module "bungeecord-storage" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name          = "${var.name}-bungeecord"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "bungeecord" {
  source    = "../../modules/bungeecord"
  name      = "${var.name}-bungeecord"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage            = module.bungeecord-storage.storage
  storage_class_name = module.bungeecord-storage.storage_class_name

  priorities = ["minecraft"]
  servers = {
    minecraft = {
      motd       = "Just another BungeeCord - Forced Host"
      address    = "minecraft:25565"
      restricted = false
    }
  }
}

