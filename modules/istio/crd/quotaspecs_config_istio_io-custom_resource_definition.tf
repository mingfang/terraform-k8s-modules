resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "quotaspecs_config_istio_io" {
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
    name = "quotaspecs.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "apim-istio-io",
      ]
      kind      = "QuotaSpec"
      list_kind = "QuotaSpecList"
      plural    = "quotaspecs"
      singular  = "quotaspec"
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
              "description": "Determines the quotas used for individual requests.",
              "properties": {
                "rules": {
                  "description": "A list of Quota rules.",
                  "items": {
                    "properties": {
                      "match": {
                        "description": "If empty, match all request.",
                        "items": {
                          "properties": {
                            "clause": {
                              "additionalProperties": {
                                "oneOf": [
                                  {
                                    "not": {
                                      "anyOf": [
                                        {
                                          "required": [
                                            "exact"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "prefix"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "regex"
                                          ]
                                        }
                                      ]
                                    }
                                  },
                                  {
                                    "required": [
                                      "exact"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "prefix"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "regex"
                                    ]
                                  }
                                ],
                                "properties": {
                                  "exact": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "prefix": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "regex": {
                                    "format": "string",
                                    "type": "string"
                                  }
                                },
                                "type": "object"
                              },
                              "description": "Map of attribute names to StringMatch type.",
                              "type": "object"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "quotas": {
                        "description": "The list of quotas to charge.",
                        "items": {
                          "properties": {
                            "charge": {
                              "format": "int32",
                              "type": "integer"
                            },
                            "quota": {
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