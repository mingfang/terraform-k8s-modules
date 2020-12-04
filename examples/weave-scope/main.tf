resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}


module "agent" {
  source    = "../../modules/weave-scope/agent"
  name      = "agent"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  weave_scope_app_url = "${module.app.name}:${module.app.ports[0].port}"
}

module "cluster-agent" {
  source    = "../../modules/weave-scope/cluster-agent"
  name      = "cluster-agent"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  weave_scope_app_url = "${module.app.name}:${module.app.ports[0].port}"
}

module "app" {
  source    = "../../modules/weave-scope/app"
  name      = "app"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "app" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "weave-scope-example.*"
    }
    name      = module.app.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.app.name
            service_port = module.app.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

