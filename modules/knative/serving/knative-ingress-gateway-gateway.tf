resource "k8s_networking_istio_io_v1alpha3_gateway" "knative-ingress-gateway" {
  metadata {
    labels = {
      "networking.knative.dev/ingress-provider" = "istio"
      "serving.knative.dev/release"             = "devel"
    }
    name      = "knative-ingress-gateway"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "selector": {
        "istio": "ingressgateway"
      },
      "servers": [
        {
          "hosts": [
            "*"
          ],
          "port": {
            "name": "http",
            "number": 80,
            "protocol": "HTTP"
          }
        },
        {
          "hosts": [
            "*"
          ],
          "port": {
            "name": "https",
            "number": 443,
            "protocol": "HTTPS"
          },
          "tls": {
            "mode": "PASSTHROUGH"
          }
        }
      ]
    }
    JSON
}