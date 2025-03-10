resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "selenium_hub" {
  source    = "../../modules/selenium/hub"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "selenium_chrome" {
  source    = "../../modules/selenium/chrome"
  name      = "${var.name}-chrome"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  HUB_HOST  = module.selenium_hub.name
}

module "selenium_firefox" {
  source    = "../../modules/selenium/firefox"
  name      = "${var.name}-firefox"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  HUB_HOST  = module.selenium_hub.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "selenium.*"
    }
    name      = module.selenium_hub.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.selenium_hub.name
      http {
        paths {
          backend {
            service_name = module.selenium_hub.name
            service_port = 4444
          }
          path = "/"
        }
      }
    }
  }
}
