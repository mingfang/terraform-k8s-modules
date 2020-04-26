resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "quotaspecbindings_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "quotaspecbindings.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "apim-istio-io",
      ]
      kind      = "QuotaSpecBinding"
      list_kind = "QuotaSpecBindingList"
      plural    = "quotaspecbindings"
      singular  = "quotaspecbinding"
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
              "properties": {
                "quotaSpecs": {
                  "items": {
                    "properties": {
                      "name": {
                        "description": "The short name of the QuotaSpec.",
                        "format": "string",
                        "type": "string"
                      },
                      "namespace": {
                        "description": "Optional namespace of the QuotaSpec.",
                        "format": "string",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "services": {
                  "description": "One or more services to map the listed QuotaSpec onto.",
                  "items": {
                    "properties": {
                      "domain": {
                        "description": "Domain suffix used to construct the service FQDN in implementations that support such specification.",
                        "format": "string",
                        "type": "string"
                      },
                      "labels": {
                        "additionalProperties": {
                          "format": "string",
                          "type": "string"
                        },
                        "description": "Optional one or more labels that uniquely identify the service version.",
                        "type": "object"
                      },
                      "name": {
                        "description": "The short name of the service such as \"foo\".",
                        "format": "string",
                        "type": "string"
                      },
                      "namespace": {
                        "description": "Optional namespace of the service.",
                        "format": "string",
                        "type": "string"
                      },
                      "service": {
                        "description": "The service FQDN.",
                        "format": "string",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
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