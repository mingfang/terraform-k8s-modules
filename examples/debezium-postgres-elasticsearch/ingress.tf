module "ingress-controller" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
  name      = "${var.name}-ingress"
  namespace = var.namespace

  node_port_http  = var.node_port_http
  node_port_https = var.node_port_https
}

module "ingress-rules" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name      = var.name
  namespace = var.namespace

  ingress_class = module.ingress-controller.ingress_class
  rules = [
    {
      host = "kafka-connect-ui.${var.ingress_host}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.debezium.kafka_connect_ui_name
              service_port = "8000"
            }
          },
        ]
      }
    },
    {
      host = "kafka-topic-ui.${var.ingress_host}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.debezium.kafka_topic_ui_name
              service_port = "8000"
            }
          },
        ]
      }
    },
    {
      host = "elasticsearch.${var.ingress_host}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.elasticsearch.name
              service_port = module.elasticsearch.port
            }
          },
        ]
      }
    },
  ]
}

output "urls" {
  value = [
    "http://${module.ingress-rules.rules[0].host}:${module.ingress-controller.node_port_http}",
    "http://${module.ingress-rules.rules.1.host}:${module.ingress-controller.node_port_http}",
    "http://${module.ingress-rules.rules.2.host}:${module.ingress-controller.node_port_http}",
  ]
}
