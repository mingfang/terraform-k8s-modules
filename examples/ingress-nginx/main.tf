resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = var.name
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = var.name
  extra_args       = ["--enable-ssl-passthrough"]
  load_balancer_ip = "192.168.2.249"
  service_type     = "LoadBalancer"
}
