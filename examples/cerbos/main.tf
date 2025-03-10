resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "cerbos" {
  length  = 32
  special = false
}

module "cerbos_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "cerbos-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  #        passwordHash: ${base64encode(bcrypt("cerbos_admin"))}

  from-map = {
    "config.yaml" = <<-EOF
    server:
      adminAPI:
        enabled: true
        adminCredentials:
          username: cerbos_admin
          passwordHash: JDJ5JDEwJE5HYnk4cTY3VTE1bFV1NlR2bmp3ME9QOXdXQXFROGtBb2lWREdEY2xXbzR6WnoxYWtSNWNDCgo=
    storage:
      driver: disk
      disk:
        directory: /policies
        watchForChanges: true
    EOF
  }
}

module "cerbos_policies" {
  source    = "../../modules/kubernetes/config-map"
  name      = "cerbos-policies"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-dir  = "${path.module}/policies"
}

module "cerbos_schemas" {
  source    = "../../modules/kubernetes/config-map"
  name      = "cerbos-schemas"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-dir  = "${path.module}/policies/_schemas"
}

module "cerbos" {
  source    = "../../modules/cerbos"
  name      = "cerbos"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  args = ["server", "--config=/config/config.yaml"]

  config_map          = module.cerbos_config.config_map
  policies_config_map = module.cerbos_policies.config_map
  schemas_config_map  = module.cerbos_schemas.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "cerbos" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.cerbos.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.cerbos.name
            service_port = module.cerbos.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
