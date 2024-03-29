resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "function" {
  metadata {
    name = "functions.openfaas.com"
  }

  spec {
    group   = "openfaas.com"
    scope = "Namespaced"
    names {
      plural      = "functions"
      singular    = "function"
      kind        = "Function"
      short_names = ["fn"]
    }
    versions {
      name    = "v1"
      served  = true
      storage = true
      schema {
      open_apiv3_schema = <<-JSON
      {
        "required": [
          "spec"
        ],
        "type": "object",
        "description": "Function describes an OpenFaaS function",
        "properties": {
          "kind": {
            "type": "string",
            "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
          },
          "spec": {
            "required": [
              "image",
              "name"
            ],
            "type": "object",
            "description": "FunctionSpec is the spec for a Function resource",
            "properties": {
              "readOnlyRootFilesystem": {
                "type": "boolean"
              },
              "name": {
                "type": "string"
              },
              "limits": {
                "type": "object",
                "description": "FunctionResources is used to set CPU and memory limits and requests",
                "properties": {
                  "cpu": {
                    "type": "string"
                  },
                  "memory": {
                    "type": "string"
                  }
                }
              },
              "secrets": {
                "items": {
                  "type": "string"
                },
                "type": "array"
              },
              "image": {
                "type": "string"
              },
              "labels": {
                "additionalProperties": {
                  "type": "string"
                },
                "type": "object"
              },
              "environment": {
                "additionalProperties": {
                  "type": "string"
                },
                "type": "object"
              },
              "handler": {
                "type": "string"
              },
              "requests": {
                "type": "object",
                "description": "FunctionResources is used to set CPU and memory limits and requests",
                "properties": {
                  "cpu": {
                    "type": "string"
                  },
                  "memory": {
                    "type": "string"
                  }
                }
              },
              "annotations": {
                "additionalProperties": {
                  "type": "string"
                },
                "type": "object"
              },
              "constraints": {
                "items": {
                  "type": "string"
                },
                "type": "array"
              }
            }
          },
          "apiVersion": {
            "type": "string",
            "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
          },
          "metadata": {
            "type": "object"
          }
        }
      }
      JSON
    }
    }
  }
}

resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "profile" {
  metadata {
    name = "profiles.openfaas.com"
  }

  spec {
    group   = "openfaas.com"
    scope = "Namespaced"
    names {
      kind      = "Profile"
      list_kind = "ProfileList"
      plural    = "profiles"
      singular  = "profile"
    }
    versions {
      name    = "v1"
      served  = true
      storage = true
      schema {
      open_apiv3_schema = <<-JSON
      {
        "required": [
          "spec"
        ],
        "type": "object",
        "description": "Profile and ProfileSpec are used to customise the Pod template for functions",
        "properties": {
          "kind": {
            "type": "string",
            "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
          },
          "spec": {
            "type": "object",
            "description": "ProfileSpec is an openfaas api extensions that can be predefined and applied to functions by annotating them with `com.openfaas/profile: name1,name2`",
            "properties": {
              "tolerations": {
                "items": {
                  "type": "object",
                  "description": "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.",
                  "properties": {
                    "operator": {
                      "type": "string",
                      "description": "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                    },
                    "key": {
                      "type": "string",
                      "description": "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                    },
                    "tolerationSeconds": {
                      "type": "integer",
                      "description": "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system.",
                      "format": "int64"
                    },
                    "effect": {
                      "type": "string",
                      "description": "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                    },
                    "value": {
                      "type": "string",
                      "description": "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                    }
                  }
                },
                "type": "array",
                "description": "If specified, the function's pod tolerations. \n merged into the Pod Tolerations"
              },
              "affinity": {
                "type": "object",
                "description": "If specified, the pod's scheduling constraints \n copied to the Pod Affinity, this will replace any existing value or previously applied Profile. We use a replacement strategy because it is not clear that merging affinities will actually produce a meaning Affinity definition, it would likely result in an impossible to satisfy constraint",
                "properties": {
                  "podAffinity": {
                    "type": "object",
                    "description": "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).",
                    "properties": {
                      "requiredDuringSchedulingIgnoredDuringExecution": {
                        "items": {
                          "required": [
                            "topologyKey"
                          ],
                          "type": "object",
                          "description": "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running",
                          "properties": {
                            "labelSelector": {
                              "type": "object",
                              "description": "A label query over a set of resources, in this case pods.",
                              "properties": {
                                "matchLabels": {
                                  "additionalProperties": {
                                    "type": "string"
                                  },
                                  "type": "object",
                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                },
                                "matchExpressions": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "key is the label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                }
                              }
                            },
                            "namespaces": {
                              "items": {
                                "type": "string"
                              },
                              "type": "array",
                              "description": "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                            },
                            "topologyKey": {
                              "type": "string",
                              "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                            }
                          }
                        },
                        "type": "array",
                        "description": "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                      },
                      "preferredDuringSchedulingIgnoredDuringExecution": {
                        "items": {
                          "required": [
                            "podAffinityTerm",
                            "weight"
                          ],
                          "type": "object",
                          "description": "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)",
                          "properties": {
                            "podAffinityTerm": {
                              "required": [
                                "topologyKey"
                              ],
                              "type": "object",
                              "description": "Required. A pod affinity term, associated with the corresponding weight.",
                              "properties": {
                                "labelSelector": {
                                  "type": "object",
                                  "description": "A label query over a set of resources, in this case pods.",
                                  "properties": {
                                    "matchLabels": {
                                      "additionalProperties": {
                                        "type": "string"
                                      },
                                      "type": "object",
                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                    },
                                    "matchExpressions": {
                                      "items": {
                                        "required": [
                                          "key",
                                          "operator"
                                        ],
                                        "type": "object",
                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                        "properties": {
                                          "operator": {
                                            "type": "string",
                                            "description": "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                          },
                                          "values": {
                                            "items": {
                                              "type": "string"
                                            },
                                            "type": "array",
                                            "description": "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                          },
                                          "key": {
                                            "type": "string",
                                            "description": "key is the label key that the selector applies to."
                                          }
                                        }
                                      },
                                      "type": "array",
                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                    }
                                  }
                                },
                                "namespaces": {
                                  "items": {
                                    "type": "string"
                                  },
                                  "type": "array",
                                  "description": "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                },
                                "topologyKey": {
                                  "type": "string",
                                  "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                }
                              }
                            },
                            "weight": {
                              "type": "integer",
                              "description": "weight associated with matching the corresponding podAffinityTerm, in the range 1-100.",
                              "format": "int32"
                            }
                          }
                        },
                        "type": "array",
                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                      }
                    }
                  },
                  "nodeAffinity": {
                    "type": "object",
                    "description": "Describes node affinity scheduling rules for the pod.",
                    "properties": {
                      "requiredDuringSchedulingIgnoredDuringExecution": {
                        "required": [
                          "nodeSelectorTerms"
                        ],
                        "type": "object",
                        "description": "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.",
                        "properties": {
                          "nodeSelectorTerms": {
                            "items": {
                              "type": "object",
                              "description": "A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.",
                              "properties": {
                                "matchFields": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "The label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "A list of node selector requirements by node's fields."
                                },
                                "matchExpressions": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "The label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "A list of node selector requirements by node's labels."
                                }
                              }
                            },
                            "type": "array",
                            "description": "Required. A list of node selector terms. The terms are ORed."
                          }
                        }
                      },
                      "preferredDuringSchedulingIgnoredDuringExecution": {
                        "items": {
                          "required": [
                            "preference",
                            "weight"
                          ],
                          "type": "object",
                          "description": "An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).",
                          "properties": {
                            "preference": {
                              "type": "object",
                              "description": "A node selector term, associated with the corresponding weight.",
                              "properties": {
                                "matchFields": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "The label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "A list of node selector requirements by node's fields."
                                },
                                "matchExpressions": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "The label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "A list of node selector requirements by node's labels."
                                }
                              }
                            },
                            "weight": {
                              "type": "integer",
                              "description": "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100.",
                              "format": "int32"
                            }
                          }
                        },
                        "type": "array",
                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred."
                      }
                    }
                  },
                  "podAntiAffinity": {
                    "type": "object",
                    "description": "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).",
                    "properties": {
                      "requiredDuringSchedulingIgnoredDuringExecution": {
                        "items": {
                          "required": [
                            "topologyKey"
                          ],
                          "type": "object",
                          "description": "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running",
                          "properties": {
                            "labelSelector": {
                              "type": "object",
                              "description": "A label query over a set of resources, in this case pods.",
                              "properties": {
                                "matchLabels": {
                                  "additionalProperties": {
                                    "type": "string"
                                  },
                                  "type": "object",
                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                },
                                "matchExpressions": {
                                  "items": {
                                    "required": [
                                      "key",
                                      "operator"
                                    ],
                                    "type": "object",
                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                    "properties": {
                                      "operator": {
                                        "type": "string",
                                        "description": "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                      },
                                      "values": {
                                        "items": {
                                          "type": "string"
                                        },
                                        "type": "array",
                                        "description": "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                      },
                                      "key": {
                                        "type": "string",
                                        "description": "key is the label key that the selector applies to."
                                      }
                                    }
                                  },
                                  "type": "array",
                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                }
                              }
                            },
                            "namespaces": {
                              "items": {
                                "type": "string"
                              },
                              "type": "array",
                              "description": "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                            },
                            "topologyKey": {
                              "type": "string",
                              "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                            }
                          }
                        },
                        "type": "array",
                        "description": "If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                      },
                      "preferredDuringSchedulingIgnoredDuringExecution": {
                        "items": {
                          "required": [
                            "podAffinityTerm",
                            "weight"
                          ],
                          "type": "object",
                          "description": "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)",
                          "properties": {
                            "podAffinityTerm": {
                              "required": [
                                "topologyKey"
                              ],
                              "type": "object",
                              "description": "Required. A pod affinity term, associated with the corresponding weight.",
                              "properties": {
                                "labelSelector": {
                                  "type": "object",
                                  "description": "A label query over a set of resources, in this case pods.",
                                  "properties": {
                                    "matchLabels": {
                                      "additionalProperties": {
                                        "type": "string"
                                      },
                                      "type": "object",
                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                    },
                                    "matchExpressions": {
                                      "items": {
                                        "required": [
                                          "key",
                                          "operator"
                                        ],
                                        "type": "object",
                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.",
                                        "properties": {
                                          "operator": {
                                            "type": "string",
                                            "description": "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                          },
                                          "values": {
                                            "items": {
                                              "type": "string"
                                            },
                                            "type": "array",
                                            "description": "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                          },
                                          "key": {
                                            "type": "string",
                                            "description": "key is the label key that the selector applies to."
                                          }
                                        }
                                      },
                                      "type": "array",
                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                    }
                                  }
                                },
                                "namespaces": {
                                  "items": {
                                    "type": "string"
                                  },
                                  "type": "array",
                                  "description": "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                },
                                "topologyKey": {
                                  "type": "string",
                                  "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                }
                              }
                            },
                            "weight": {
                              "type": "integer",
                              "description": "weight associated with matching the corresponding podAffinityTerm, in the range 1-100.",
                              "format": "int32"
                            }
                          }
                        },
                        "type": "array",
                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                      }
                    }
                  }
                }
              },
              "runtimeClassName": {
                "type": "string",
                "description": "RuntimeClassName refers to a RuntimeClass object in the node.k8s.io group, which should be used to run this pod.  If no RuntimeClass resource matches the named class, the pod will not be run. If unset or empty, the \"legacy\" RuntimeClass will be used, which is an implicit class with an empty definition that uses the default runtime handler. More info: https://git.k8s.io/enhancements/keps/sig-node/runtime-class.md This is a beta feature as of Kubernetes v1.14. \n copied to the Pod RunTimeClass, this will replace any existing value or previously applied Profile."
              },
              "podSecurityContext": {
                "type": "object",
                "description": "SecurityContext holds pod-level security attributes and common container settings. Optional: Defaults to empty.  See type description for default values of each field. \n each non-nil value will be merged into the function's PodSecurityContext, the value will replace any existing value or previously applied Profile",
                "properties": {
                  "runAsGroup": {
                    "type": "integer",
                    "description": "The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.",
                    "format": "int64"
                  },
                  "runAsUser": {
                    "type": "integer",
                    "description": "The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.",
                    "format": "int64"
                  },
                  "supplementalGroups": {
                    "items": {
                      "type": "integer",
                      "format": "int64"
                    },
                    "type": "array",
                    "description": "A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container."
                  },
                  "fsGroup": {
                    "type": "integer",
                    "description": "A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod: \n 1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw---- \n If unset, the Kubelet will not modify the ownership and permissions of any volume.",
                    "format": "int64"
                  },
                  "seLinuxOptions": {
                    "type": "object",
                    "description": "The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.",
                    "properties": {
                      "role": {
                        "type": "string",
                        "description": "Role is a SELinux role label that applies to the container."
                      },
                      "type": {
                        "type": "string",
                        "description": "Type is a SELinux type label that applies to the container."
                      },
                      "user": {
                        "type": "string",
                        "description": "User is a SELinux user label that applies to the container."
                      },
                      "level": {
                        "type": "string",
                        "description": "Level is SELinux level label that applies to the container."
                      }
                    }
                  },
                  "runAsNonRoot": {
                    "type": "boolean",
                    "description": "Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                  },
                  "windowsOptions": {
                    "type": "object",
                    "description": "The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.",
                    "properties": {
                      "gmsaCredentialSpec": {
                        "type": "string",
                        "description": "GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field."
                      },
                      "gmsaCredentialSpecName": {
                        "type": "string",
                        "description": "GMSACredentialSpecName is the name of the GMSA credential spec to use."
                      },
                      "runAsUserName": {
                        "type": "string",
                        "description": "The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                      }
                    }
                  },
                  "sysctls": {
                    "items": {
                      "required": [
                        "name",
                        "value"
                      ],
                      "type": "object",
                      "description": "Sysctl defines a kernel parameter to be set",
                      "properties": {
                        "name": {
                          "type": "string",
                          "description": "Name of a property to set"
                        },
                        "value": {
                          "type": "string",
                          "description": "Value of a property to set"
                        }
                      }
                    },
                    "type": "array",
                    "description": "Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch."
                  },
                  "fsGroupChangePolicy": {
                    "type": "string",
                    "description": "fsGroupChangePolicy defines behavior of changing ownership and permission of the volume before being exposed inside Pod. This field will only apply to volume types which support fsGroup based ownership(and permissions). It will have no effect on ephemeral volume types such as: secret, configmaps and emptydir. Valid values are \"OnRootMismatch\" and \"Always\". If not specified defaults to \"Always\"."
                  }
                }
              }
            }
          },
          "apiVersion": {
            "type": "string",
            "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
          },
          "metadata": {
            "type": "object"
          }
        }
      }
      JSON
    }
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
