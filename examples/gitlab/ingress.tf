module "ingress-controller" {
  source          = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
  name            = "${var.name}-ingress-controller"
  namespace       = "default"
  node_port_http  = "${var.ingress_node_port_http}"
  node_port_https = "${var.ingress_node_port_https}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name = "${var.name}-ingress"

    annotations {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    }
    ingress_class = "nginx"
  }

  spec {
    rules = [
      {
        host = "gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
              }
            },
          ]
        }
      },
      {
        host = "mattermost.gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
              }
            },
          ]
        }
      },
      {
        host = "registry.gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
              }
            },
          ]
        }
      },
    ]
  }
}

output "urls" {
  value = [
    "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules[0].host}:${module.ingress-controller.node_port_http}",
    "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules.1.host}:${module.ingress-controller.node_port_http}",
    "http://${k8s_extensions_v1beta1_ingress.this.spec[0].rules.2.host}:${module.ingress-controller.node_port_http}",
  ]
}
