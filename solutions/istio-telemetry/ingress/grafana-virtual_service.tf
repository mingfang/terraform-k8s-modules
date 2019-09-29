resource "k8s_networking_istio_io_v1alpha3_virtual_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "istio-system"
  }
  spec = <<-JSON
    {
      "gateways": [
        "telemetry-gateway"
      ],
      "hosts": [
        "*"
      ],
      "http": [
        {
          "match": [
            {
              "authority": {
                "prefix": "grafana"
              }
            }
          ],
          "route": [
            {
              "destination": {
                "host": "grafana",
                "port": {
                  "number": 3000
                }
              }
            }
          ]
        }
      ]
    }
    JSON
}