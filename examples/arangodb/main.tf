resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  env = [
    //    {
    //      name = "ARANGO_NO_AUTH"
    //      value = 1
    //    },
    {
      name  = "ARANGO_ROOT_PASSWORD"
      value = "arangodb"
    },
  ]
}

module "jwt-secret-file" {
  source    = "../../modules/kubernetes/secret"
  name      = "jwt-secret-file"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "jwt-secret-file" = base64encode("foobar")
  }
}

module "agency" {
  source    = "../../modules/arangodb/agency"
  name      = "agency"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 3
  storage       = "1Gi"
  storage_class = "cephfs"

  env                = local.env
  jwt-secret-keyfile = module.jwt-secret-file.name
}

module "dbserver" {
  source    = "../../modules/arangodb/dbserver"
  name      = "dbserver"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 4
  storage       = "1Gi"
  storage_class = "cephfs"

  env                      = local.env
  cluster-agency-endpoints = module.agency.cluster-agency-endpoints
  jwt-secret-keyfile       = module.jwt-secret-file.name
}

module "coordinator" {
  source    = "../../modules/arangodb/coordinator"
  name      = "coordinator"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  env                      = local.env
  cluster-agency-endpoints = module.agency.cluster-agency-endpoints
  jwt-secret-keyfile       = module.jwt-secret-file.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "arangodb-example.*"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = module.coordinator.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.coordinator.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.coordinator.name
            service_port = module.coordinator.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

