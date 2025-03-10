resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "serviceroles_rbac_istio_io" {
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
    name = "serviceroles.rbac.istio.io"
  }
  spec {
    group = "rbac.istio.io"
    names {
      categories = [
        "istio-io",
        "rbac-istio-io",
      ]
      kind      = "ServiceRole"
      list_kind = "ServiceRoleList"
      plural    = "serviceroles"
      singular  = "servicerole"
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
                "rules": {
                  "description": "The set of access rules (permissions) that the role has.",
                  "items": {
                    "properties": {
                      "constraints": {
                        "description": "Optional.",
                        "items": {
                          "properties": {
                            "key": {
                              "description": "Key of the constraint.",
                              "format": "string",
                              "type": "string"
                            },
                            "values": {
                              "description": "List of valid values for the constraint.",
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
                      },
                      "hosts": {
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
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "notMethods": {
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "notPaths": {
                        "items": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "notPorts": {
                        "items": {
                          "format": "int32",
                          "type": "integer"
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
                        "items": {
                          "format": "int32",
                          "type": "integer"
                        },
                        "type": "array"
                      },
                      "services": {
                        "description": "A list of service names.",
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