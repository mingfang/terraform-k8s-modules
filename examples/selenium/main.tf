module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# Selenium Hub — Grid 4 hub exposing the WebDriver endpoint (4444) and the
# event bus ports (4442 publish / 4443 subscribe) that nodes connect to.
module "selenium_hub" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "selenium/hub:4.46.0-20260707"
  ports_map = {
    publish   = 4442
    subscribe = 4443
    webdriver = 4444
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/status"
      port = 4444
    }
  }
}

# Chrome node — registers with the hub via the event bus and exposes VNC
# (5900) and noVNC (7900) for interactive debugging.
module "selenium_chrome" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-chrome"
  namespace = module.namespace.name
  image     = "selenium/node-chrome:4.46.0-20260707"
  ports_map = {
    vnc   = 5900
    novnc = 7900
  }

  env_map = {
    SE_EVENT_BUS_HOST = module.selenium_hub.name
  }

  volumes = [
    {
      name = "shm"
      empty_dir = {
        medium     = "Memory"
        size_limit = "2Gi"
      }
      mount_path = "/dev/shm"
    },
  ]
}

# Firefox node — same shape as the Chrome node.
module "selenium_firefox" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-firefox"
  namespace = module.namespace.name
  image     = "selenium/node-firefox:4.46.0-20260707"
  ports_map = {
    vnc   = 5900
    novnc = 7900
  }

  env_map = {
    SE_EVENT_BUS_HOST = module.selenium_hub.name
  }

  volumes = [
    {
      name = "shm"
      empty_dir = {
        medium     = "Memory"
        size_limit = "2Gi"
      }
      mount_path = "/dev/shm"
    },
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "selenium.*"
    }
    name      = module.selenium_hub.name
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = module.selenium_hub.name
      http {
        paths {
          backend {
            service {
              name = module.selenium_hub.name
              port {
                number = module.selenium_hub.ports_map.webdriver
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
