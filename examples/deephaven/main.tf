resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}


module "server" {
  source    = "../../modules/deephaven/server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

module "web" {
  source    = "../../modules/deephaven/web"
  name      = "web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

module "grpc-proxy" {
  source       = "../../modules/deephaven/grpc-proxy"
  name         = "grpc-proxy"
  namespace    = k8s_core_v1_namespace.this.metadata[0].name
  BACKEND_ADDR = "${module.server.name}:${module.server.ports[0].port}"
}

module "envoy" {
  source    = "../../modules/deephaven/envoy"
  name      = "envoy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "3600"
    }
    name      = module.envoy.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "${module.envoy.name}.${var.namespace}"
      http {
        paths {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.envoy.name
              port {
                number = module.envoy.ports[0].port
              }
            }
          }
        }
      }
    }
  }
}
/*
resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "3600"
    }
    name      = module.envoy.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "${module.envoy.name}.${var.namespace}"
      http {
        paths {
          path = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.grpc-proxy.name
              port {
                number = module.grpc-proxy.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/ide"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/jsapi"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/js-plugins"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/notebooks"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/layouts"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
        paths {
          path = "/iframe"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.web.name
              port {
                number = module.web.ports[0].port
              }
            }
          }
        }
      }
    }
  }
}
*/
