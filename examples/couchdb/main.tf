resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "db_username" = base64encode("foo")
    "db_password" = base64encode("bar")
  }
}

module "couchdb" {
  source    = "../../modules/couchdb"
  name      = "couchdb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 2
  storage       = "1Gi"
  storage_class = var.storage_class_name

  db_secret_name  = module.secret.name
  db_username_key = "db_username"
  db_password_key = "db_password"

}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.couchdb.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.couchdb.name
            service_port = module.couchdb.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
