resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "gateways_networking_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "gateways.networking.istio.io"
  }
  spec {
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind      = "Gateway"
      list_kind = "GatewayList"
      plural    = "gateways"
      short_names = [
        "gw",
      ]
      singular = "gateway"
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
              "description": "Configuration affecting edge load balancer. See more details at: https://istio.io/docs/reference/config/networking/gateway.html",
              "properties": {
                "selector": {
                  "additionalProperties": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "object"
                },
                "servers": {
                  "description": "A list of server specifications.",
                  "items": {
                    "properties": {
                      "bind": {
                        "format": "string",
                        "type": "string"
                      },
                      "defaultEndpoint": {
                        "format": "string",
                        "type": "string"
                      },
                      "hosts": {
                        "description": "One or more hosts exposed by this gateway.",
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "port": {
                        "properties": {
                          "name": {
                            "description": "Label assigned to the port.",
                            "format": "string",
                            "type": "string"
                          },
                          "number": {
                            "description": "A valid non-negative integer port number.",
                            "type": "integer"
                          },
                          "protocol": {
                            "description": "The protocol exposed on the port.",
                            "format": "string",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "tls": {
                        "description": "Set of TLS related options that govern the server's behavior.",
                        "properties": {
                          "caCertificates": {
                            "description": "REQUIRED if mode is `MUTUAL`.",
                            "format": "string",
                            "type": "string"
                          },
                          "cipherSuites": {
                            "description": "Optional: If specified, only support the specified cipher list.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "credentialName": {
                            "format": "string",
                            "type": "string"
                          },
                          "httpsRedirect": {
                            "type": "boolean"
                          },
                          "maxProtocolVersion": {
                            "description": "Optional: Maximum TLS protocol version.",
                            "enum": [
                              "TLS_AUTO",
                              "TLSV1_0",
                              "TLSV1_1",
                              "TLSV1_2",
                              "TLSV1_3"
                            ],
                            "type": "string"
                          },
                          "minProtocolVersion": {
                            "description": "Optional: Minimum TLS protocol version.",
                            "enum": [
                              "TLS_AUTO",
                              "TLSV1_0",
                              "TLSV1_1",
                              "TLSV1_2",
                              "TLSV1_3"
                            ],
                            "type": "string"
                          },
                          "mode": {
                            "enum": [
                              "PASSTHROUGH",
                              "SIMPLE",
                              "MUTUAL",
                              "AUTO_PASSTHROUGH",
                              "ISTIO_MUTUAL"
                            ],
                            "type": "string"
                          },
                          "privateKey": {
                            "description": "REQUIRED if mode is `SIMPLE` or `MUTUAL`.",
                            "format": "string",
                            "type": "string"
                          },
                          "serverCertificate": {
                            "description": "REQUIRED if mode is `SIMPLE` or `MUTUAL`.",
                            "format": "string",
                            "type": "string"
                          },
                          "subjectAltNames": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "verifyCertificateHash": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "verifyCertificateSpki": {
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
      name    = "v1alpha3"
      served  = true
      storage = true
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = false
    }
  }
}