"resource" "k8s_rbac_authorization_k8s_io_v1_cluster_role" "kong-ingress-clusterrole" {
  "metadata" = [
    {
      "name" = "kong-ingress-clusterrole"
    },
  ]

  "rules" = [
    {
      "api_groups" = [""]

      "resources" = ["endpoints", "nodes", "pods", "secrets"]

      "verbs" = ["list", "watch"]
    },
    {
      "api_groups" = [""]

      "resources" = ["nodes"]

      "verbs" = ["get"]
    },
    {
      "api_groups" = [""]

      "resources" = ["services"]

      "verbs" = ["get", "list", "watch"]
    },
    {
      "api_groups" = ["extensions"]

      "resources" = ["ingresses"]

      "verbs" = ["get", "list", "watch"]
    },
    {
      "api_groups" = [""]

      "resources" = ["events"]

      "verbs" = ["create", "patch"]
    },
    {
      "api_groups" = ["extensions"]

      "resources" = ["ingresses/status"]

      "verbs" = ["update"]
    },
    {
      "api_groups" = ["configuration.konghq.com"]

      "resources" = ["kongplugins", "kongcredentials", "kongconsumers", "kongingresses"]

      "verbs" = ["get", "list", "watch"]
    },
  ]
}
