resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "handlers_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-handler"
      "package"  = "handler"
      "release"  = "istio"
    }
    name = "handlers.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind      = "handler"
      list_kind = "handlerList"
      plural    = "handlers"
      singular  = "handler"
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
              "description": "Handler allows the operator to configure a specific adapter implementation.",
              "properties": {
                "adapter": {
                  "description": "The name of a specific adapter implementation.",
                  "format": "string",
                  "type": "string"
                },
                "compiledAdapter": {
                  "description": "The name of the compiled in adapter this handler instantiates.",
                  "format": "string",
                  "type": "string"
                },
                "connection": {
                  "description": "Information on how to connect to the out-of-process adapter.",
                  "properties": {
                    "address": {
                      "description": "The address of the backend.",
                      "format": "string",
                      "type": "string"
                    },
                    "authentication": {
                      "description": "Auth config for the connection to the backend.",
                      "oneOf": [
                        {
                          "not": {
                            "anyOf": [
                              {
                                "properties": {
                                  "tls": {
                                    "allOf": [
                                      {
                                        "oneOf": [
                                          {
                                            "not": {
                                              "anyOf": [
                                                {
                                                  "required": [
                                                    "tokenPath"
                                                  ]
                                                },
                                                {
                                                  "required": [
                                                    "oauth"
                                                  ]
                                                }
                                              ]
                                            }
                                          },
                                          {
                                            "required": [
                                              "tokenPath"
                                            ]
                                          },
                                          {
                                            "required": [
                                              "oauth"
                                            ]
                                          }
                                        ]
                                      },
                                      {
                                        "oneOf": [
                                          {
                                            "not": {
                                              "anyOf": [
                                                {
                                                  "required": [
                                                    "authHeader"
                                                  ]
                                                },
                                                {
                                                  "required": [
                                                    "customHeader"
                                                  ]
                                                }
                                              ]
                                            }
                                          },
                                          {
                                            "required": [
                                              "authHeader"
                                            ]
                                          },
                                          {
                                            "required": [
                                              "customHeader"
                                            ]
                                          }
                                        ]
                                      }
                                    ]
                                  }
                                },
                                "required": [
                                  "tls"
                                ]
                              },
                              {
                                "required": [
                                  "mutual"
                                ]
                              }
                            ]
                          }
                        },
                        {
                          "properties": {
                            "tls": {
                              "allOf": [
                                {
                                  "oneOf": [
                                    {
                                      "not": {
                                        "anyOf": [
                                          {
                                            "required": [
                                              "tokenPath"
                                            ]
                                          },
                                          {
                                            "required": [
                                              "oauth"
                                            ]
                                          }
                                        ]
                                      }
                                    },
                                    {
                                      "required": [
                                        "tokenPath"
                                      ]
                                    },
                                    {
                                      "required": [
                                        "oauth"
                                      ]
                                    }
                                  ]
                                },
                                {
                                  "oneOf": [
                                    {
                                      "not": {
                                        "anyOf": [
                                          {
                                            "required": [
                                              "authHeader"
                                            ]
                                          },
                                          {
                                            "required": [
                                              "customHeader"
                                            ]
                                          }
                                        ]
                                      }
                                    },
                                    {
                                      "required": [
                                        "authHeader"
                                      ]
                                    },
                                    {
                                      "required": [
                                        "customHeader"
                                      ]
                                    }
                                  ]
                                }
                              ]
                            }
                          },
                          "required": [
                            "tls"
                          ]
                        },
                        {
                          "required": [
                            "mutual"
                          ]
                        }
                      ],
                      "properties": {
                        "mutual": {
                          "properties": {
                            "caCertificates": {
                              "format": "string",
                              "type": "string"
                            },
                            "clientCertificate": {
                              "description": "The path to the file holding client certificate for mutual TLS.",
                              "format": "string",
                              "type": "string"
                            },
                            "privateKey": {
                              "description": "The path to the file holding the private key for mutual TLS.",
                              "format": "string",
                              "type": "string"
                            },
                            "serverName": {
                              "description": "Used to configure mixer mutual TLS client to supply server name for SNI.",
                              "format": "string",
                              "type": "string"
                            }
                          },
                          "type": "object"
                        },
                        "tls": {
                          "properties": {
                            "authHeader": {
                              "description": "Access token is passed as authorization header.",
                              "enum": [
                                "PLAIN",
                                "BEARER"
                              ],
                              "type": "string"
                            },
                            "caCertificates": {
                              "format": "string",
                              "type": "string"
                            },
                            "customHeader": {
                              "description": "Customized header key to hold access token, e.g.",
                              "format": "string",
                              "type": "string"
                            },
                            "oauth": {
                              "description": "Oauth config to fetch access token from auth provider.",
                              "properties": {
                                "clientId": {
                                  "description": "OAuth client id for mixer.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "clientSecret": {
                                  "description": "The path to the file holding the client secret for oauth.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "endpointParams": {
                                  "additionalProperties": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "description": "Additional parameters for requests to the token endpoint.",
                                  "type": "object"
                                },
                                "scopes": {
                                  "description": "List of requested permissions.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "tokenUrl": {
                                  "description": "The Resource server's token endpoint URL.",
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "serverName": {
                              "format": "string",
                              "type": "string"
                            },
                            "tokenPath": {
                              "format": "string",
                              "type": "string"
                            }
                          },
                          "type": "object"
                        }
                      },
                      "type": "object"
                    },
                    "timeout": {
                      "description": "Timeout for remote calls to the backend.",
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "name": {
                  "description": "Must be unique in the entire Mixer configuration.",
                  "format": "string",
                  "type": "string"
                },
                "params": {
                  "description": "Depends on adapter implementation.",
                  "type": "object"
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