resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "authorizationpolicies_security_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "security"
      "release"  = "istio"
    }
    name = "authorizationpolicies.security.istio.io"
  }
  spec {
    group = "security.istio.io"
    names {
      categories = [
        "istio-io",
        "security-istio-io",
      ]
      kind      = "AuthorizationPolicy"
      list_kind = "AuthorizationPolicyList"
      plural    = "authorizationpolicies"
      singular  = "authorizationpolicy"
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
              "description": "Configuration for access control on workloads. See more details at: https://istio.io/docs/reference/config/security/authorization-policy.html",
              "properties": {
                "action": {
                  "description": "Optional.",
                  "enum": [
                    "ALLOW",
                    "DENY"
                  ],
                  "type": "string"
                },
                "rules": {
                  "description": "Optional.",
                  "items": {
                    "properties": {
                      "from": {
                        "description": "Optional.",
                        "items": {
                          "properties": {
                            "source": {
                              "description": "Source specifies the source of a request.",
                              "properties": {
                                "ipBlocks": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "namespaces": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notIpBlocks": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notNamespaces": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notPrincipals": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notRequestPrincipals": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "principals": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "requestPrincipals": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                }
                              },
                              "type": "object"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "to": {
                        "description": "Optional.",
                        "items": {
                          "properties": {
                            "operation": {
                              "description": "Operation specifies the operation of a request.",
                              "properties": {
                                "hosts": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "methods": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notHosts": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notMethods": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notPaths": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "notPorts": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "paths": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                },
                                "ports": {
                                  "description": "Optional.",
                                  "items": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "type": "array"
                                }
                              },
                              "type": "object"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "when": {
                        "description": "Optional.",
                        "items": {
                          "properties": {
                            "key": {
                              "description": "The name of an Istio attribute.",
                              "format": "string",
                              "type": "string"
                            },
                            "notValues": {
                              "description": "Optional.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "values": {
                              "description": "Optional.",
                              "items": {
                                "format": "string",
                                "type": "string"
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
                  },
                  "type": "array"
                },
                "selector": {
                  "description": "Optional.",
                  "properties": {
                    "matchLabels": {
                      "additionalProperties": {
                        "format": "string",
                        "type": "string"
                      },
                      "type": "object"
                    }
                  },
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
      name    = "v1beta1"
      served  = true
      storage = true
    }
  }
}