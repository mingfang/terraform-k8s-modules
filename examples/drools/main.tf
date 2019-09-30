variable "name" {
  default = "drools"
}

variable "namespace" {
  default = "drools-example"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "workbench" {
  source    = "../../modules/drools/workbench"
  name      = "workbench"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "kie-server" {
  source         = "../../modules/drools/kie-server"
  name           = "kie-server"
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  replicas       = 2

  kie_server_id = "Sales"
  controller_url = "ws://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/websocket/controller"
  maven_repo_url = "http://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/maven2"
}

module "kie-server2" {
  source         = "../../modules/drools/kie-server"
  name           = "kie-server2"
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  replicas       = 2

  kie_server_id = "Finance"
  controller_url = "ws://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/websocket/controller"
  maven_repo_url = "http://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/maven2"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "drools.*",
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "3600",
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600",
    }
  }
  spec {
    rules {
      host = var.name
      http {
        paths {
          backend {
            service_name = module.workbench.service.metadata[0].name
            service_port = module.workbench.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
