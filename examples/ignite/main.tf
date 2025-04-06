module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "ignite_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "ignite-config"
  namespace = module.namespace.name

  from-map = {
    "ignite-config.conf" = <<-EOF
    {
      ignite: {
        network: {
          port: 3344,
          nodeFinder: {
            netClusterNodes: [
              "ignite-srv:3344"
            ]
          }
        }
      }
    }
    EOF
  }
}

module "ignite" {
  source    = "../../modules/generic-statefulset-service"
  name      = "ignite"
  namespace = module.namespace.name
  image     = "apacheignite/ignite:3.0.0"
  replicas  = var.replicas
  ports_map = {
    rest    = 10300
    sql     = 10800
    cluster = 3344
  }

  configmap            = module.ignite_config.config_map
  configmap_mount_path = "/opt/ignite/etc"

  env_map = {
    IGNITE_NODE_NAME       = "$(POD_NAME)"
    IGNITE_WORK_DIR        = "/data"
    IGNITE3_EXTRA_JVM_ARGS = ""
  }

  resources = {
    limits = {
      cpu    = "4"
      memory = "4Gi"
    }
    requests = {
      cpu    = "4"
      memory = "4Gi"
    }
  }

  storage    = "1Gi"
  mount_path = "/data"
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
              name = module.ignite.name
              port {
                number = module.ignite.ports_map.rest
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

locals {
  metastorage_group = join(",", [for i in range(0, min(var.replicas, 3)) : "${module.ignite.name}-${i}"])
}

module "ignite_init" {
  source    = "../../modules/kubernetes/job"
  name      = "ignite-init"
  namespace = module.namespace.name
  image     = "apacheignite/ignite:3.0.0"

  command = [
    "bash", "-cx", <<-EOF
      $${IGNITE_CLI_HOME}/bin/ignite3 cluster init \
        --name=${var.namespace} \
        --metastorage-group=${local.metastorage_group} \
        --url=http://${module.ignite.name}.${var.namespace}:${module.ignite.ports_map.rest}
      EOF
  ]
}
