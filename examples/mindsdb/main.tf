module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = var.name
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "mindsdb" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "mindsdb/mindsdb"
  ports_map = { http = 47334, mysql = 47335, mcp = 47337 }

  env_map = {
    MINDSDB_APIS = "http,mysql,postgres,mcp"
  }

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
      mount_path = "/root/mdb_storage"
    },
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.mindsdb.name
              port {
                number = module.mindsdb.ports_map.http
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
