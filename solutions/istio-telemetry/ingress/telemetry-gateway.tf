resource "k8s_networking_istio_io_v1alpha3_gateway" "telemetry-gateway" {
  metadata {
    name      = "telemetry-gateway"
    namespace = "istio-system"
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
        }
      ]
    }
    JSON
}