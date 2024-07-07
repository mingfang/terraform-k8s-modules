resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "cloudeventsources_eventing_keda_sh" {
  metadata {
    annotations = {
      "controller-gen.kubebuilder.io/version" = "v0.14.0"
    }
    labels = {
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "cloudeventsources.eventing.keda.sh"
  }
  spec {
    group = "eventing.keda.sh"
    names {
      kind      = "CloudEventSource"
      list_kind = "CloudEventSourceList"
      plural    = "cloudeventsources"
      singular  = "cloudeventsource"
    }
    scope = "Namespaced"

    versions {

      additional_printer_columns {
        json_path = <<-EOF
          .status.conditions[?(@.type=="Active")].status
          EOF
        name      = "Active"
        type      = "string"
      }
      name = "v1alpha1"
      schema {
        open_apiv3_schema = <<-JSON
          {
            "description": "CloudEventSource defines how a KEDA event will be sent to event sink",
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "spec": {
                "description": "CloudEventSourceSpec defines the spec of CloudEventSource",
                "properties": {
                  "authenticationRef": {
                    "description": "AuthenticationRef points to the TriggerAuthentication or ClusterTriggerAuthentication object that\nis used to authenticate the scaler with the environment",
                    "properties": {
                      "kind": {
                        "description": "Kind of the resource being referred to. Defaults to TriggerAuthentication.",
                        "type": "string"
                      },
                      "name": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "name"
                    ],
                    "type": "object"
                  },
                  "clusterName": {
                    "type": "string"
                  },
                  "destination": {
                    "description": "Destination defines the various ways to emit events",
                    "properties": {
                      "azureEventGridTopic": {
                        "properties": {
                          "endpoint": {
                            "type": "string"
                          }
                        },
                        "required": [
                          "endpoint"
                        ],
                        "type": "object"
                      },
                      "http": {
                        "properties": {
                          "uri": {
                            "type": "string"
                          }
                        },
                        "required": [
                          "uri"
                        ],
                        "type": "object"
                      }
                    },
                    "type": "object"
                  },
                  "eventSubscription": {
                    "description": "EventSubscription defines filters for events",
                    "properties": {
                      "excludedEventTypes": {
                        "items": {
                          "description": "CloudEventType contains the list of cloudevent types",
                          "enum": [
                            "keda.scaledobject.ready.v1",
                            "keda.scaledobject.failed.v1"
                          ],
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "includedEventTypes": {
                        "items": {
                          "description": "CloudEventType contains the list of cloudevent types",
                          "enum": [
                            "keda.scaledobject.ready.v1",
                            "keda.scaledobject.failed.v1"
                          ],
                          "type": "string"
                        },
                        "type": "array"
                      }
                    },
                    "type": "object"
                  }
                },
                "required": [
                  "destination"
                ],
                "type": "object"
              },
              "status": {
                "description": "CloudEventSourceStatus defines the observed state of CloudEventSource",
                "properties": {
                  "conditions": {
                    "description": "Conditions an array representation to store multiple Conditions",
                    "items": {
                      "description": "Condition to store the condition state",
                      "properties": {
                        "message": {
                          "description": "A human readable message indicating details about the transition.",
                          "type": "string"
                        },
                        "reason": {
                          "description": "The reason for the condition's last transition.",
                          "type": "string"
                        },
                        "status": {
                          "description": "Status of the condition, one of True, False, Unknown.",
                          "type": "string"
                        },
                        "type": {
                          "description": "Type of condition",
                          "type": "string"
                        }
                      },
                      "required": [
                        "status",
                        "type"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  }
                },
                "type": "object"
              }
            },
            "required": [
              "spec"
            ],
            "type": "object"
          }
          JSON
      }
      served  = true
      storage = true
      subresources {
        status = { "" = "" }
      }
    }
  }
}