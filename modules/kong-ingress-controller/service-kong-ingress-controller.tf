"resource" "k8s_core_v1_service" "kong-ingress-controller" {
  "metadata" = [
    {
      "name" = "kong-ingress-controller"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "ports" = [
        {
          "name" = "kong-admin"

          "port" = 8001

          "protocol" = "TCP"

          "target_port" = 8001
        },
      ]

      "selector" = {
        "app" = "ingress-kong"
      }

      "type" = "NodePort"
    },
  ]
}
