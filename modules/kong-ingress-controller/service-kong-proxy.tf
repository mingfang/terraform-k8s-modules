"resource" "k8s_core_v1_service" "kong-proxy" {
  "metadata" = [
    {
      "name" = "kong-proxy"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "ports" = [
        {
          "name" = "kong-proxy"

          "port" = 80

          "protocol" = "TCP"

          "target_port" = 8000
        },
        {
          "name" = "kong-proxy-ssl"

          "port" = 443

          "protocol" = "TCP"

          "target_port" = 8443
        },
      ]

      "selector" = {
        "app" = "kong"
      }

      "type" = "LoadBalancer"
    },
  ]
}
