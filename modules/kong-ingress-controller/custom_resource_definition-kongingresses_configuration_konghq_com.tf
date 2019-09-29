"resource" "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "kongingresses_configuration_konghq_com" {
  "metadata" = [
    {
      "name" = "kongingresses.configuration.konghq.com"
    },
  ]

  "spec" = [
    {
      "group" = "configuration.konghq.com"

      "names" = [
        {
          "kind" = "KongIngress"

          "plural" = "kongingresses"

          "short_names" = ["ki"]
        },
      ]

      "scope" = "Namespaced"

      "version" = "v1"
    },
  ]
}
