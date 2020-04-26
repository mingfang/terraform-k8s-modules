resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "sidecars_networking_istio_io" {
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
    name = "sidecars.networking.istio.io"
  }
  spec {
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind      = "Sidecar"
      list_kind = "SidecarList"
      plural    = "sidecars"
      singular  = "sidecar"
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
              "description": "Configuration affecting network reachability of a sidecar. See more details at: https://istio.io/docs/reference/config/networking/sidecar.html",
              "properties": {
                "egress": {
                  "items": {
                    "properties": {
                      "bind": {
                        "format": "string",
                        "type": "string"
                      },
                      "captureMode": {
                        "enum": [
                          "DEFAULT",
                          "IPTABLES",
                          "NONE"
                        ],
                        "type": "string"
                      },
                      "hosts": {
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "port": {
                        "description": "The port associated with the listener.",
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
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "ingress": {
                  "items": {
                    "properties": {
                      "bind": {
                        "description": "The IP to which the listener should be bound.",
                        "format": "string",
                        "type": "string"
                      },
                      "captureMode": {
                        "enum": [
                          "DEFAULT",
                          "IPTABLES",
                          "NONE"
                        ],
                        "type": "string"
                      },
                      "defaultEndpoint": {
                        "format": "string",
                        "type": "string"
                      },
                      "port": {
                        "description": "The port associated with the listener.",
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
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "outboundTrafficPolicy": {
                  "description": "This allows to configure the outbound traffic policy.",
                  "properties": {
                    "mode": {
                      "enum": [
                        "REGISTRY_ONLY",
                        "ALLOW_ANY"
                      ],
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "workloadSelector": {
                  "properties": {
                    "labels": {
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