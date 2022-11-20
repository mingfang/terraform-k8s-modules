resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "pd" {
  source    = "../../modules/tidb/pd"
  name      = "pd"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

}

module "tikv" {
  source    = "../../modules/tidb/tikv"
  name      = "tikv"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

  pd = module.pd.pd
}

module "surrealdb" {
  source    = "../../modules/surrealdb"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  args = ["start", "tikv://${module.pd.name}:${module.pd.ports[0].port}"]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.surrealdb.name
            service_port = module.surrealdb.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
