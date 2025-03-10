resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "serviceentries_networking_istio_io" {
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
    name = "serviceentries.networking.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.hosts"
      description = "The hosts associated with the ServiceEntry"
      name        = "Hosts"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.location"
      description = "Whether the service is external to the mesh or part of the mesh (MESH_EXTERNAL or MESH_INTERNAL)"
      name        = "Location"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.resolution"
      description = "Service discovery mode for the hosts (NONE, STATIC, or DNS)"
      name        = "Resolution"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata"
      name        = "Age"
      type        = "date"
    }
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind      = "ServiceEntry"
      list_kind = "ServiceEntryList"
      plural    = "serviceentries"
      short_names = [
        "se",
      ]
      singular = "serviceentry"
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
              "description": "Configuration affecting service registry. See more details at: https://istio.io/docs/reference/config/networking/service-entry.html",
              "properties": {
                "addresses": {
                  "description": "The virtual IP addresses associated with the service.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "endpoints": {
                  "description": "One or more endpoints associated with the service.",
                  "items": {
                    "properties": {
                      "address": {
                        "format": "string",
                        "type": "string"
                      },
                      "labels": {
                        "additionalProperties": {
                          "format": "string",
                          "type": "string"
                        },
                        "description": "One or more labels associated with the endpoint.",
                        "type": "object"
                      },
                      "locality": {
                        "description": "The locality associated with the endpoint.",
                        "format": "string",
                        "type": "string"
                      },
                      "network": {
                        "format": "string",
                        "type": "string"
                      },
                      "ports": {
                        "additionalProperties": {
                          "type": "integer"
                        },
                        "description": "Set of ports associated with the endpoint.",
                        "type": "object"
                      },
                      "weight": {
                        "description": "The load balancing weight associated with the endpoint.",
                        "type": "integer"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "exportTo": {
                  "description": "A list of namespaces to which this service is exported.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "hosts": {
                  "description": "The hosts associated with the ServiceEntry.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "location": {
                  "enum": [
                    "MESH_EXTERNAL",
                    "MESH_INTERNAL"
                  ],
                  "type": "string"
                },
                "ports": {
                  "description": "The ports associated with the external service.",
                  "items": {
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
                  "type": "array"
                },
                "resolution": {
                  "description": "Service discovery mode for the hosts.",
                  "enum": [
                    "NONE",
                    "STATIC",
                    "DNS"
                  ],
                  "type": "string"
                },
                "subjectAltNames": {
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