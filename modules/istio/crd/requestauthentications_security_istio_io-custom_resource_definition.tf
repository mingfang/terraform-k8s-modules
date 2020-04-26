resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "requestauthentications_security_istio_io" {
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
    name = "requestauthentications.security.istio.io"
  }
  spec {
    group = "security.istio.io"
    names {
      categories = [
        "istio-io",
        "security-istio-io",
      ]
      kind      = "RequestAuthentication"
      list_kind = "RequestAuthenticationList"
      plural    = "requestauthentications"
      singular  = "requestauthentication"
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
              "description": "RequestAuthentication defines what request authentication methods are supported by a workload.",
              "properties": {
                "jwtRules": {
                  "description": "Define the list of JWTs that can be validated at the selected workloads' proxy.",
                  "items": {
                    "properties": {
                      "audiences": {
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "forwardOriginalToken": {
                        "description": "If set to true, the orginal token will be kept for the ustream request.",
                        "type": "boolean"
                      },
                      "fromHeaders": {
                        "description": "List of header locations from which JWT is expected.",
                        "items": {
                          "properties": {
                            "name": {
                              "description": "The HTTP header name.",
                              "format": "string",
                              "type": "string"
                            },
                            "prefix": {
                              "description": "The prefix that should be stripped before decoding the token.",
                              "format": "string",
                              "type": "string"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "fromParams": {
                        "description": "List of query parameters from which JWT is expected.",
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
                      "outputPayloadToHeader": {
                        "format": "string",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "selector": {
                  "description": "The selector determines the workloads to apply the RequestAuthentication on.",
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