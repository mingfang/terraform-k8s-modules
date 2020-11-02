resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cluster-admin" {
  metadata {
    name = "cluster-admin:${k8s_core_v1_namespace.this.metadata[0].name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subjects {
    kind      = "ServiceAccount"
    name      = module.dashboard.service_account.metadata[0].name
    namespace = module.dashboard.service_account.metadata[0].namespace
  }
}

module "dashboard" {
  source    = "../../modules/kubernetes/dashboard"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  args = [
    "--enable-skip-login=true",
  ]
}
module "dashboard-metrics-scraper" {
  source    = "../../modules/kubernetes/dashboard-metrics-scraper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "dashboard-example.*"
    }
    name      = module.dashboard.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.dashboard.name
            service_port = module.dashboard.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
