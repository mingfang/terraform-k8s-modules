resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "dgraph-zero" {
  source    = "../../modules/dgraph/dgraph-zero"
  name      = "${var.name}-zero"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = var.storage_class_name
}

module "dgraph-alpha" {
  source    = "../../modules/dgraph/dgraph-alpha"
  name      = "${var.name}-alpha"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = var.storage_class_name

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

resource "k8s_networking_k8s_io_v1beta1_ingress" "dgraph-nginx" {
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
      host = "${module.dgraph-nginx.name}.${var.namespace}"
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

resource "k8s_networking_k8s_io_v1beta1_ingress" "dgraph-grpc" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                  = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"     = "dgraph-grpc.*"
      "nginx.ingress.kubernetes.io/backend-protocol" = "GRPC"
    }
    name      = "${module.dgraph-alpha.name}-grpc"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.dgraph-alpha.name}-grpc.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.dgraph-alpha.name
            service_port = 9080
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "dgraph-alpha" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dgraph-alpha.*"
    }
    name      = module.dgraph-alpha.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.dgraph-alpha.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.dgraph-alpha.name
            service_port = module.dgraph-alpha.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
