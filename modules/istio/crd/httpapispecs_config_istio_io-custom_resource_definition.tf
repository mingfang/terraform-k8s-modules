resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "httpapispecs_config_istio_io" {
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
    name = "httpapispecs.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "apim-istio-io",
      ]
      kind      = "HTTPAPISpec"
      list_kind = "HTTPAPISpecList"
      plural    = "httpapispecs"
      singular  = "httpapispec"
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
                "apiKeys": {
                  "items": {
                    "oneOf": [
                      {
                        "not": {
                          "anyOf": [
                            {
                              "required": [
                                "query"
                              ]
                            },
                            {
                              "required": [
                                "header"
                              ]
                            },
                            {
                              "required": [
                                "cookie"
                              ]
                            }
                          ]
                        }
                      },
                      {
                        "required": [
                          "query"
                        ]
                      },
                      {
                        "required": [
                          "header"
                        ]
                      },
                      {
                        "required": [
                          "cookie"
                        ]
                      }
                    ],
                    "properties": {
                      "cookie": {
                        "format": "string",
                        "type": "string"
                      },
                      "header": {
                        "description": "API key is sent in a request header.",
                        "format": "string",
                        "type": "string"
                      },
                      "query": {
                        "description": "API Key is sent as a query parameter.",
                        "format": "string",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "api_keys": {
                  "items": {
                    "oneOf": [
                      {
                        "not": {
                          "anyOf": [
                            {
                              "required": [
                                "query"
                              ]
                            },
                            {
                              "required": [
                                "header"
                              ]
                            },
                            {
                              "required": [
                                "cookie"
                              ]
                            }
                          ]
                        }
                      },
                      {
                        "required": [
                          "query"
                        ]
                      },
                      {
                        "required": [
                          "header"
                        ]
                      },
                      {
                        "required": [
                          "cookie"
                        ]
                      }
                    ],
                    "properties": {
                      "cookie": {
                        "format": "string",
                        "type": "string"
                      },
                      "header": {
                        "description": "API key is sent in a request header.",
                        "format": "string",
                        "type": "string"
                      },
                      "query": {
                        "description": "API Key is sent as a query parameter.",
                        "format": "string",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "attributes": {
                  "properties": {
                    "attributes": {
                      "additionalProperties": {
                        "oneOf": [
                          {
                            "not": {
                              "anyOf": [
                                {
                                  "required": [
                                    "stringValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "int64Value"
                                  ]
                                },
                                {
                                  "required": [
                                    "doubleValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "boolValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "bytesValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "timestampValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "durationValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "stringMapValue"
                                  ]
                                }
                              ]
                            }
                          },
                          {
                            "required": [
                              "stringValue"
                            ]
                          },
                          {
                            "required": [
                              "int64Value"
                            ]
                          },
                          {
                            "required": [
                              "doubleValue"
                            ]
                          },
                          {
                            "required": [
                              "boolValue"
                            ]
                          },
                          {
                            "required": [
                              "bytesValue"
                            ]
                          },
                          {
                            "required": [
                              "timestampValue"
                            ]
                          },
                          {
                            "required": [
                              "durationValue"
                            ]
                          },
                          {
                            "required": [
                              "stringMapValue"
                            ]
                          }
                        ],
                        "properties": {
                          "boolValue": {
                            "type": "boolean"
                          },
                          "bytesValue": {
                            "format": "binary",
                            "type": "string"
                          },
                          "doubleValue": {
                            "format": "double",
                            "type": "number"
                          },
                          "durationValue": {
                            "type": "string"
                          },
                          "int64Value": {
                            "format": "int64",
                            "type": "integer"
                          },
                          "stringMapValue": {
                            "properties": {
                              "entries": {
                                "additionalProperties": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "description": "Holds a set of name/value pairs.",
                                "type": "object"
                              }
                            },
                            "type": "object"
                          },
                          "stringValue": {
                            "format": "string",
                            "type": "string"
                          },
                          "timestampValue": {
                            "format": "dateTime",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "description": "A map of attribute name to its value.",
                      "type": "object"
                    }
                  },
                  "type": "object"
                },
                "patterns": {
                  "description": "List of HTTP patterns to match.",
                  "items": {
                    "oneOf": [
                      {
                        "not": {
                          "anyOf": [
                            {
                              "required": [
                                "uriTemplate"
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
                          "uriTemplate"
                        ]
                      },
                      {
                        "required": [
                          "regex"
                        ]
                      }
                    ],
                    "properties": {
                      "attributes": {
                        "properties": {
                          "attributes": {
                            "additionalProperties": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "stringValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "int64Value"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "doubleValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "boolValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "bytesValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "timestampValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "durationValue"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "stringMapValue"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "stringValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "int64Value"
                                  ]
                                },
                                {
                                  "required": [
                                    "doubleValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "boolValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "bytesValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "timestampValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "durationValue"
                                  ]
                                },
                                {
                                  "required": [
                                    "stringMapValue"
                                  ]
                                }
                              ],
                              "properties": {
                                "boolValue": {
                                  "type": "boolean"
                                },
                                "bytesValue": {
                                  "format": "binary",
                                  "type": "string"
                                },
                                "doubleValue": {
                                  "format": "double",
                                  "type": "number"
                                },
                                "durationValue": {
                                  "type": "string"
                                },
                                "int64Value": {
                                  "format": "int64",
                                  "type": "integer"
                                },
                                "stringMapValue": {
                                  "properties": {
                                    "entries": {
                                      "additionalProperties": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "description": "Holds a set of name/value pairs.",
                                      "type": "object"
                                    }
                                  },
                                  "type": "object"
                                },
                                "stringValue": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "timestampValue": {
                                  "format": "dateTime",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "description": "A map of attribute name to its value.",
                            "type": "object"
                          }
                        },
                        "type": "object"
                      },
                      "httpMethod": {
                        "format": "string",
                        "type": "string"
                      },
                      "regex": {
                        "format": "string",
                        "type": "string"
                      },
                      "uriTemplate": {
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