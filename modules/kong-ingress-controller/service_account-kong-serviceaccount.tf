"resource" "k8s_core_v1_service_account" "kong-serviceaccount" {
  "metadata" = [
    {
      "name" = "kong-serviceaccount"

      "namespace" = "kong"
    },
  ]
}
