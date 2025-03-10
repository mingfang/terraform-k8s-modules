resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "rbacconfigs_rbac_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "rbac"
      "package"  = "istio.io.mixer"
      "release"  = "istio"
    }
    name = "rbacconfigs.rbac.istio.io"
  }
  spec {
    group = "rbac.istio.io"
    names {
      categories = [
        "istio-io",
        "rbac-istio-io",
      ]
      kind      = "RbacConfig"
      list_kind = "RbacConfigList"
      plural    = "rbacconfigs"
      singular  = "rbacconfig"
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
              "description": "Configuration for Role Based Access Control. See more details at: https://istio.io/docs/reference/config/security/istio.rbac.v1alpha1.html",
              "properties": {
                "enforcementMode": {
                  "enum": [
                    "ENFORCED",
                    "PERMISSIVE"
                  ],
                  "type": "string"
                },
                "exclusion": {
                  "description": "A list of services or namespaces that should not be enforced by Istio RBAC policies.",
                  "properties": {
                    "namespaces": {
                      "description": "A list of namespaces.",
                      "items": {
                        "format": "string",
                        "type": "string"
                      },
                      "type": "array"
                    },
                    "services": {
                      "description": "A list of services.",
                      "items": {
                        "format": "string",
                        "type": "string"
                      },
                      "type": "array"
                    }
                  },
                  "type": "object"
                },
                "inclusion": {
                  "description": "A list of services or namespaces that should be enforced by Istio RBAC policies.",
                  "properties": {
                    "namespaces": {
                      "description": "A list of namespaces.",
                      "items": {
                        "format": "string",
                        "type": "string"
                      },
                      "type": "array"
                    },
                    "services": {
                      "description": "A list of services.",
                      "items": {
                        "format": "string",
                        "type": "string"
                      },
                      "type": "array"
                    }
                  },
                  "type": "object"
                },
                "mode": {
                  "description": "Istio RBAC mode.",
                  "enum": [
                    "OFF",
                    "ON",
                    "ON_WITH_INCLUSION",
                    "ON_WITH_EXCLUSION"
                  ],
                  "type": "string"
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