resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "instances_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-instance"
      "package"  = "instance"
      "release"  = "istio"
    }
    name = "instances.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind      = "instance"
      list_kind = "instanceList"
      plural    = "instances"
      singular  = "instance"
    }
    scope = "Namespaced"
    subresources {
      status = {
      }
    }
    validation {
      open_apiv3_schema = <<-JSON
        {
          "properties": {
            "spec": {
              "description": "An Instance tells Mixer how to create instances for particular template.",
              "properties": {
                "attributeBindings": {
                  "additionalProperties": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "object"
                },
                "compiledTemplate": {
                  "description": "The name of the compiled in template this instance creates instances for.",
                  "format": "string",
                  "type": "string"
                },
                "name": {
                  "format": "string",
                  "type": "string"
                },
                "params": {
                  "description": "Depends on referenced template.",
                  "type": "object"
                },
                "template": {
                  "description": "The name of the template this instance creates instances for.",
                  "format": "string",
                  "type": "string"
                }
              },
              "type": "object"
            }
          },
          "type": "object"
        }
        JSON
    }

    versions {
      name    = "v1alpha2"
      served  = true
      storage = true
    }
  }
}