"resource" "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "kongplugins_configuration_konghq_com" {
  "metadata" = [
    {
      "name" = "kongplugins.configuration.konghq.com"
    },
  ]

  "spec" = [
    {
      "additional_printer_columns" = [
        {
          "description" = "Name of the plugin"

          "json_path" = ".plugin"

          "name" = "Plugin-Type"

          "type" = "string"
        },
        {
          "description" = "Age"

          "json_path" = ".metadata.creationTimestamp"

          "name" = "Age"

          "type" = "date"
        },
        {
          "description" = "Indicates if the plugin is disabled"

          "json_path" = ".disabled"

          "name" = "Disabled"

          "priority" = 1

          "type" = "boolean"
        },
        {
          "description" = "Configuration of the plugin"

          "json_path" = ".config"

          "name" = "Config"

          "priority" = 1

          "type" = "string"
        },
      ]

      "group" = "configuration.konghq.com"

      "names" = [
        {
          "kind" = "KongPlugin"

          "plural" = "kongplugins"

          "short_names" = ["kp"]
        },
      ]

      "scope" = "Namespaced"

      "version" = "v1"
    },
  ]
}
