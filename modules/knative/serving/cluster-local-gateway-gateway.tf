resource "k8s_networking_istio_io_v1alpha3_gateway" "cluster-local-gateway" {
  metadata {
    labels = {
      "networking.knative.dev/ingress-provider" = "istio"
      "serving.knative.dev/release"             = "devel"
    }
    name      = "cluster-local-gateway"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "selector": {
        "istio": "cluster-local-gateway"
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