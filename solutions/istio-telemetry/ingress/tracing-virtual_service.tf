resource "k8s_networking_istio_io_v1alpha3_virtual_service" "tracing" {
  metadata {
    name      = "tracing"
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
                "prefix": "tracing"
              }
            }
          ],
          "route": [
            {
              "destination": {
                "host": "tracing",
                "port": {
                  "number": 80
                }
              }
            }
          ]
        }
      ]
    }
    JSON
}