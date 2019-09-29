resource "k8s_networking_istio_io_v1alpha3_destination_rule" "istio-policy" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-policy"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "host": "istio-policy.${var.namespace}.svc.cluster.local",
      "trafficPolicy": {
        "connectionPool": {
          "http": {
            "http2MaxRequests": 10000,
            "maxRequestsPerConnection": 10000
          }
        }
      }
    }
    JSON
}