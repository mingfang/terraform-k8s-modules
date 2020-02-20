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

module "dgraph-zero-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "dgraph-zero"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "dgraph-zero" {
  source    = "../../modules/dgraph/dgraph-zero"
  name      = "${var.name}-zero"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.dgraph-zero-storage.replicas
  storage       = module.dgraph-zero-storage.storage
  storage_class = module.dgraph-zero-storage.storage_class_name
}

module "dgraph-alpha-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "dgraph-alpha"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "dgraph-alpha" {
  source    = "../../modules/dgraph/dgraph-alpha"
  name      = "${var.name}-alpha"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.dgraph-alpha-storage.replicas
  storage       = module.dgraph-alpha-storage.storage
  storage_class = module.dgraph-alpha-storage.storage_class_name

  peer = module.dgraph-zero.peer
}

module "dgraph-ratel" {
  source    = "../../modules/dgraph/dgraph-ratel"
  name      = "${var.name}-ratel"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "dgraph-nginx" {
  source    = "../../modules/nginx"
  name      = "${var.name}-nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  default-conf = <<-EOF
    server {
      listen      80;

      location /query {
        # Since Play Dgraph is read-only with no new mutations, all queries can be
        # ran with best-effort (param be=true) to avoid making a network call to
        # Zero and waiting for the MaxAssigned timestamp.
        set $delimeter "";
        if ($is_args) {
          set $delimeter "&";
        }
        set $args $args$${delimeter}be=true;

        # Pass to the Dgraph Alpha running on this machine
        proxy_pass http://${module.dgraph-alpha.name}:8080;
      }

      location ~ ^/(mutate|alter|health|ui/keywords) {
        # Pass to the Dgraph Alpha running on this machine
        proxy_pass http://${module.dgraph-alpha.name}:8080;
      }

      location / {
        # Pass to the Ratel instance running on this machine
        proxy_pass http://${module.dgraph-ratel.name}:8000;
      }
    }
    EOF
}

resource "k8s_extensions_v1beta1_ingress" "dgraph-nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dgraph-nginx.*"
    }
    name      = module.dgraph-nginx.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.dgraph-nginx.name
      http {
        paths {
          backend {
            service_name = module.dgraph-nginx.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}
