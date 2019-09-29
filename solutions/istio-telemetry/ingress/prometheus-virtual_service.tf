resource "k8s_networking_istio_io_v1alpha3_virtual_service" "prometheus" {
  metadata {
    name      = "prometheus"
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
                "prefix": "prometheus"
              }
            }
          ],
          "route": [
            {
              "destination": {
                "host": "prometheus",
                "port": {
                  "number": 9090
                }
              }
            }
          ]
        }
      ]
    }
    JSON
}