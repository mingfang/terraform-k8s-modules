resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "function" {
  metadata {
    name = "functions.openfaas.com"
  }

  spec {
    group   = "openfaas.com"
    version = "v1"
    versions {
      name    = "v1"
      served  = true
      storage = true
    }
    versions {
      name    = "v1alpha2"
      served  = true
      storage = false
    }
    names {
      plural      = "functions"
      singular    = "function"
      kind        = "Function"
      short_names = ["fn"]
    }
    scope = "Namespaced"
    validation {
      open_apiv3_schema = <<-JSON
      {
        "properties": {
          "spec": {
            "required": [
              "name",
              "image"
            ],
            "properties": {
              "readOnlyRootFilesystem": {
                "type": "boolean"
              },
              "name": {
                "pattern": "^[a-z0-9]([-a-z0-9]*[a-z0-9])?$",
                "type": "string"
              },
              "limits": {
                "properties": {
                  "cpu": {
                    "pattern": "^[0-9]+(m)",
                    "type": "string"
                  },
                  "memory": {
                    "pattern": "^[0-9]+(Mi|Gi)",
                    "type": "string"
                  }
                }
              },
              "secrets": {
                "type": "array"
              },
              "image": {
                "type": "string"
              },
              "labels": {
                "anyOf": [
                  {
                    "type": "string"
                  },
                  {
                    "type": "object"
                  }
                ]
              },
              "requests": {
                "properties": {
                  "cpu": {
                    "pattern": "^[0-9]+(m)",
                    "type": "string"
                  },
                  "memory": {
                    "pattern": "^[0-9]+(Mi|Gi)",
                    "type": "string"
                  }
                }
              },
              "annotations": {
                "anyOf": [
                  {
                    "type": "string"
                  },
                  {
                    "type": "object"
                  }
                ]
              },
              "constraints": {
                "type": "array"
              }
            }
          }
        }
      }
      JSON
    }
  }
}

resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "policy" {
  metadata {
    name = "policies.openfaas.com"
  }

  spec {
    group   = "openfaas.com"
    version = "v1"
    versions {
      name    = "v1"
      served  = true
      storage = true
    }
    versions {
      name    = "v1alpha1"
      served  = true
      storage = false
    }
    names {
      plural      = "policies"
      singular    = "policy"
      kind        = "Policy"
      short_names = ["pol"]
    }
    scope = "Namespaced"
  }
}
