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

module "orientdb_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "orientdb" {
  source    = "../../modules/orientdb"
  name      = var.name
  namespace = var.namespace

  storage_class = module.orientdb_storage.storage_class_name
  storage       = module.orientdb_storage.storage
  replicas      = module.orientdb_storage.replicas

  ORIENTDB_ROOT_PASSWORD = "orientpwd"
  //to work with NFS
  args = "-Dstorage.wal.allowDirectIO=false"
}

//depends on examples/ingress-nginx
resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx-example"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
      "nginx.ingress.kubernetes.io/affinity"     = "cookie"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      //must be set for sticky session to work
      host = "orientdb.192.168.2.249.nip.io"
      http {
        paths {
          backend {
            service_name = module.orientdb.name
            service_port = module.orientdb.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

