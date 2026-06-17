module "ingress-controller" {
  source          = "../../modules/kubernetes/ingress-nginx"
  name            = "${var.name}-ingress-controller"
  namespace       = "default"
  node_port_http  = "${var.ingress_node_port_http}"
  node_port_https = "${var.ingress_node_port_https}"
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    name = "${var.name}-ingress"

    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    }
    ingress_class = "nginx"
  }

  spec {
    ingress_class_name = "nginx"
    rules = [
      {
        host = "gitlab.${var.ingress_host}.nip.io"

        http = {
          paths = [
            {
              path = "/"
              path_type = "ImplementationSpecific"

              backend = {
                service {
                  name = ${var.name}
                  port {
                    number = "80"
                  }
                }
              }
            },
          ]
        }
      },
      {
        host = "mattermost.gitlab.${var.ingress_host}.nip.io"

        http = {
          paths = [
            {
              path = "/"
              path_type = "ImplementationSpecific"

              backend = {
                service {
                  name = ${var.name}
                  port {
                    number = "80"
                  }
                }
              }
            },
          ]
        }
      },
      {
        host = "registry.gitlab.${var.ingress_host}.nip.io"

        http = {
          paths = [
            {
              path = "/"
              path_type = "ImplementationSpecific"

              backend = {
                service {
                  name = ${var.name}
                  port {
                    number = "80"
                  }
                }
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
    "http://${k8s_networking_k8s_io_v1_ingress.this.spec[0].rules[0].host}:${module.ingress-controller.node_port_http}",
    "http://${k8s_networking_k8s_io_v1_ingress.this.spec[0].rules.1.host}:${module.ingress-controller.node_port_http}",
    "http://${k8s_networking_k8s_io_v1_ingress.this.spec[0].rules.2.host}:${module.ingress-controller.node_port_http}",
  ]
}
