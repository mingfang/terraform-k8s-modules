"resource" "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "kongcredentials_configuration_konghq_com" {
  "metadata" = [
    {
      "name" = "kongcredentials.configuration.konghq.com"
    },
  ]

  "spec" = [
    {
      "additional_printer_columns" = [
        {
          "description" = "Type of credential"

          "json_path" = ".type"

          "name" = "Credential-type"

          "type" = "string"
        },
        {
          "description" = "Age"

          "json_path" = ".metadata.creationTimestamp"

          "name" = "Age"

          "type" = "date"
        },
        {
          "description" = "Owner of the credential"

          "json_path" = ".consumerRef"

          "name" = "Consumer-Ref"

          "type" = "string"
        },
      ]

      "group" = "configuration.konghq.com"

      "names" = [
        {
          "kind" = "KongCredential"

          "plural" = "kongcredentials"
        },
      ]

      "scope" = "Namespaced"

      "version" = "v1"
    },
  ]
}
