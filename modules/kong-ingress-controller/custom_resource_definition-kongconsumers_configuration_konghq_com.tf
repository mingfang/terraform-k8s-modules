"resource" "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "kongconsumers_configuration_konghq_com" {
  "metadata" = [
    {
      "name" = "kongconsumers.configuration.konghq.com"
    },
  ]

  "spec" = [
    {
      "additional_printer_columns" = [
        {
          "description" = "Username of a Kong Consumer"

          "json_path" = ".username"

          "name" = "Username"

          "type" = "string"
        },
        {
          "description" = "Age"

          "json_path" = ".metadata.creationTimestamp"

          "name" = "Age"

          "type" = "date"
        },
      ]

      "group" = "configuration.konghq.com"

      "names" = [
        {
          "kind" = "KongConsumer"

          "plural" = "kongconsumers"

          "short_names" = ["kc"]
        },
      ]

      "scope" = "Namespaced"

      "version" = "v1"
    },
  ]
}
