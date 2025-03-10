resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "meshpolicies_authentication_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-citadel"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "meshpolicies.authentication.istio.io"
  }
  spec {
    group = "authentication.istio.io"
    names {
      categories = [
        "istio-io",
        "authentication-istio-io",
      ]
      kind      = "MeshPolicy"
      list_kind = "MeshPolicyList"
      plural    = "meshpolicies"
      singular  = "meshpolicy"
    }
    scope = "Cluster"
    subresources {
      status = {
      }
    }
    validation {
      open_apiv3_schema = <<-JSON
        {
          "properties": {
            "spec": {
              "description": "Authentication policy for Istio services. See more details at: https://istio.io/docs/reference/config/security/istio.authentication.v1alpha1.html",
              "properties": {
                "originIsOptional": {
                  "description": "Deprecated.",
                  "type": "boolean"
                },
                "origins": {
                  "description": "Deprecated.",
                  "items": {
                    "properties": {
                      "jwt": {
                        "description": "Jwt params for the method.",
                        "properties": {
                          "audiences": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "issuer": {
                            "description": "Identifies the issuer that issued the JWT.",
                            "format": "string",
                            "type": "string"
                          },
                          "jwks": {
                            "description": "JSON Web Key Set of public keys to validate signature of the JWT.",
                            "format": "string",
                            "type": "string"
                          },
                          "jwksUri": {
                            "format": "string",
                            "type": "string"
                          },
                          "jwks_uri": {
                            "format": "string",
                            "type": "string"
                          },
                          "jwtHeaders": {
                            "description": "JWT is sent in a request header.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "jwtParams": {
                            "description": "JWT is sent in a query parameter.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "jwt_headers": {
                            "description": "JWT is sent in a request header.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "triggerRules": {
                            "items": {
                              "properties": {
                                "excludedPaths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "excluded_paths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "includedPaths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "included_paths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
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
                          },
                          "trigger_rules": {
                            "items": {
                              "properties": {
                                "excludedPaths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "excluded_paths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "includedPaths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "included_paths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
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
                  },
                  "type": "array"
                },
                "peerIsOptional": {
                  "description": "Deprecated.",
                  "type": "boolean"
                },
                "peers": {
                  "description": "List of authentication methods that can be used for peer authentication.",
                  "items": {
                    "oneOf": [
                      {
                        "not": {
                          "anyOf": [
                            {
                              "required": [
                                "mtls"
                              ]
                            },
                            {
                              "properties": {
                                "jwt": {}
                              },
                              "required": [
                                "jwt"
                              ]
                            }
                          ]
                        }
                      },
                      {
                        "required": [
                          "mtls"
                        ]
                      },
                      {
                        "properties": {
                          "jwt": {}
                        },
                        "required": [
                          "jwt"
                        ]
                      }
                    ],
                    "properties": {
                      "jwt": {
                        "properties": {
                          "audiences": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "issuer": {
                            "description": "Identifies the issuer that issued the JWT.",
                            "format": "string",
                            "type": "string"
                          },
                          "jwks": {
                            "description": "JSON Web Key Set of public keys to validate signature of the JWT.",
                            "format": "string",
                            "type": "string"
                          },
                          "jwksUri": {
                            "format": "string",
                            "type": "string"
                          },
                          "jwks_uri": {
                            "format": "string",
                            "type": "string"
                          },
                          "jwtHeaders": {
                            "description": "JWT is sent in a request header.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "jwtParams": {
                            "description": "JWT is sent in a query parameter.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "jwt_headers": {
                            "description": "JWT is sent in a request header.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "triggerRules": {
                            "items": {
                              "properties": {
                                "excludedPaths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "excluded_paths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "includedPaths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "included_paths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
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
                          },
                          "trigger_rules": {
                            "items": {
                              "properties": {
                                "excludedPaths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "excluded_paths": {
                                  "description": "List of paths to be excluded from the request.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "includedPaths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "type": "array"
                                },
                                "included_paths": {
                                  "description": "List of paths that the request must include.",
                                  "items": {
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
                                                "suffix"
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
                                          "suffix"
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
                                        "description": "exact string match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "prefix": {
                                        "description": "prefix-based match.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "regex": {
                                        "description": "ECMAscript style regex-based match as defined by [EDCA-262](http://en.cppreference.com/w/cpp/regex/ecmascript).",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "suffix": {
                                        "description": "suffix-based match.",
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
                      },
                      "mtls": {
                        "description": "Set if mTLS is used.",
                        "properties": {
                          "allowTls": {
                            "description": "Deprecated.",
                            "type": "boolean"
                          },
                          "mode": {
                            "description": "Defines the mode of mTLS authentication.",
                            "enum": [
                              "STRICT",
                              "PERMISSIVE"
                            ],
                            "type": "string"
                          }
                        },
                        "type": "object"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "principalBinding": {
                  "description": "Deprecated.",
                  "enum": [
                    "USE_PEER",
                    "USE_ORIGIN"
                  ],
                  "type": "string"
                },
                "targets": {
                  "description": "Deprecated.",
                  "items": {
                    "properties": {
                      "name": {
                        "description": "The name must be a short name from the service registry.",
                        "format": "string",
                        "type": "string"
                      },
                      "ports": {
                        "description": "Specifies the ports.",
                        "items": {
                          "oneOf": [
                            {
                              "not": {
                                "anyOf": [
                                  {
                                    "required": [
                                      "number"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "name"
                                    ]
                                  }
                                ]
                              }
                            },
                            {
                              "required": [
                                "number"
                              ]
                            },
                            {
                              "required": [
                                "name"
                              ]
                            }
                          ],
                          "properties": {
                            "name": {
                              "format": "string",
                              "type": "string"
                            },
                            "number": {
                              "type": "integer"
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
      name    = "v1alpha1"
      served  = true
      storage = true
    }
  }
}