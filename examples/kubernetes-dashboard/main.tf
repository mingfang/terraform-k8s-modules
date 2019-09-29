variable "name" {
  default = "dashboard"
}

module "dashboard" {
  source    = "../../modules/kubernetes/dashboard"
  name      = var.name
  namespace = "kube-system"
}

module "ingress-rules" {
  source        = "../../modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = "kube-system"
  ingress_class = "example"
  annotations = {
    "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS",
    "nginx.ingress.kubernetes.io/rewrite-target"   = "/",
    "nginx.ingress.kubernetes.io/ssl-passthrough"  = "true",
  }
  rules = [
    {
      host = var.name

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = var.name
              service_port = module.dashboard.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
  ]
}