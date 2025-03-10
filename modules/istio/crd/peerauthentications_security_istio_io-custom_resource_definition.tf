resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "peerauthentications_security_istio_io" {
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
    name = "peerauthentications.security.istio.io"
  }
  spec {
    group = "security.istio.io"
    names {
      categories = [
        "istio-io",
        "security-istio-io",
      ]
      kind      = "PeerAuthentication"
      list_kind = "PeerAuthenticationList"
      plural    = "peerauthentications"
      singular  = "peerauthentication"
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
              "description": "PeerAuthentication defines how traffic will be tunneled (or not) to the sidecar.",
              "properties": {
                "mtls": {
                  "description": "Mutual TLS settings for workload.",
                  "properties": {
                    "mode": {
                      "description": "Defines the mTLS mode used for peer authentication.",
                      "enum": [
                        "UNSET",
                        "DISABLE",
                        "PERMISSIVE",
                        "STRICT"
                      ],
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "portLevelMtls": {
                  "additionalProperties": {
                    "properties": {
                      "mode": {
                        "description": "Defines the mTLS mode used for peer authentication.",
                        "enum": [
                          "UNSET",
                          "DISABLE",
                          "PERMISSIVE",
                          "STRICT"
                        ],
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "description": "Port specific mutual TLS settings.",
                  "type": "object"
                },
                "selector": {
                  "description": "The selector determines the workloads to apply the ChannelAuthentication on.",
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