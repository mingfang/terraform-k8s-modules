resource "k8s_networking_istio_io_v1alpha3_virtual_service" "kiali" {
  metadata {
    name      = "kiali"
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
                "prefix": "kiali"
              },
              "uri": {
                "exact": "/"
              }
            }
          ],
          "redirect": {
            "uri": "/kiali"
          }
        },
        {
          "match": [
            {
              "authority": {
                "prefix": "kiali"
              }
            }
          ],
          "route": [
            {
              "destination": {
                "host": "kiali",
                "port": {
                  "number": 20001
                }
              }
            }
          ]
        }
      ]
    }
    JSON
}