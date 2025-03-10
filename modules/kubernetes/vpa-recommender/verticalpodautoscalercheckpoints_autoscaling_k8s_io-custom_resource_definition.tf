resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "verticalpodautoscalercheckpoints_autoscaling_k8s_io" {
  metadata {
    annotations = {
      "api-approved.kubernetes.io"            = "https://github.com/kubernetes/kubernetes/pull/63797"
      "controller-gen.kubebuilder.io/version" = "v0.9.2"
    }
    name = "verticalpodautoscalercheckpoints.autoscaling.k8s.io"
  }
  spec {
    group = "autoscaling.k8s.io"
    names {
      kind      = "VerticalPodAutoscalerCheckpoint"
      list_kind = "VerticalPodAutoscalerCheckpointList"
      plural    = "verticalpodautoscalercheckpoints"
      short_names = [
        "vpacheckpoint",
      ]
      singular = "verticalpodautoscalercheckpoint"
    }
    scope = "Namespaced"

    versions {
      name = "v1"
      schema {
        open_apiv3_schema = <<-JSON
          {
            "description": "VerticalPodAutoscalerCheckpoint is the checkpoint of the internal state of VPA that is used for recovery after recommender's restart.",
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "spec": {
                "description": "Specification of the checkpoint. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status.",
                "properties": {
                  "containerName": {
                    "description": "Name of the checkpointed container.",
                    "type": "string"
                  },
                  "vpaObjectName": {
                    "description": "Name of the VPA object that stored VerticalPodAutoscalerCheckpoint object.",
                    "type": "string"
                  }
                },
                "type": "object"
              },
              "status": {
                "description": "Data of the checkpoint.",
                "properties": {
                  "cpuHistogram": {
                    "description": "Checkpoint of histogram for consumption of CPU.",
                    "properties": {
                      "bucketWeights": {
                        "description": "Map from bucket index to bucket weight.",
                        "type": "object",
                        "x-kubernetes-preserve-unknown-fields": true
                      },
                      "referenceTimestamp": {
                        "description": "Reference timestamp for samples collected within this histogram.",
                        "format": "date-time",
                        "nullable": true,
                        "type": "string"
                      },
                      "totalWeight": {
                        "description": "Sum of samples to be used as denominator for weights from BucketWeights.",
                        "type": "number"
                      }
                    },
                    "type": "object"
                  },
                  "firstSampleStart": {
                    "description": "Timestamp of the fist sample from the histograms.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "lastSampleStart": {
                    "description": "Timestamp of the last sample from the histograms.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "lastUpdateTime": {
                    "description": "The time when the status was last refreshed.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "memoryHistogram": {
                    "description": "Checkpoint of histogram for consumption of memory.",
                    "properties": {
                      "bucketWeights": {
                        "description": "Map from bucket index to bucket weight.",
                        "type": "object",
                        "x-kubernetes-preserve-unknown-fields": true
                      },
                      "referenceTimestamp": {
                        "description": "Reference timestamp for samples collected within this histogram.",
                        "format": "date-time",
                        "nullable": true,
                        "type": "string"
                      },
                      "totalWeight": {
                        "description": "Sum of samples to be used as denominator for weights from BucketWeights.",
                        "type": "number"
                      }
                    },
                    "type": "object"
                  },
                  "totalSamplesCount": {
                    "description": "Total number of samples in the histograms.",
                    "type": "integer"
                  },
                  "version": {
                    "description": "Version of the format of the stored data.",
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
      served  = true
      storage = true
    }
    versions {
      name = "v1beta2"
      schema {
        open_apiv3_schema = <<-JSON
          {
            "description": "VerticalPodAutoscalerCheckpoint is the checkpoint of the internal state of VPA that is used for recovery after recommender's restart.",
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "spec": {
                "description": "Specification of the checkpoint. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status.",
                "properties": {
                  "containerName": {
                    "description": "Name of the checkpointed container.",
                    "type": "string"
                  },
                  "vpaObjectName": {
                    "description": "Name of the VPA object that stored VerticalPodAutoscalerCheckpoint object.",
                    "type": "string"
                  }
                },
                "type": "object"
              },
              "status": {
                "description": "Data of the checkpoint.",
                "properties": {
                  "cpuHistogram": {
                    "description": "Checkpoint of histogram for consumption of CPU.",
                    "properties": {
                      "bucketWeights": {
                        "description": "Map from bucket index to bucket weight.",
                        "type": "object",
                        "x-kubernetes-preserve-unknown-fields": true
                      },
                      "referenceTimestamp": {
                        "description": "Reference timestamp for samples collected within this histogram.",
                        "format": "date-time",
                        "nullable": true,
                        "type": "string"
                      },
                      "totalWeight": {
                        "description": "Sum of samples to be used as denominator for weights from BucketWeights.",
                        "type": "number"
                      }
                    },
                    "type": "object"
                  },
                  "firstSampleStart": {
                    "description": "Timestamp of the fist sample from the histograms.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "lastSampleStart": {
                    "description": "Timestamp of the last sample from the histograms.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "lastUpdateTime": {
                    "description": "The time when the status was last refreshed.",
                    "format": "date-time",
                    "nullable": true,
                    "type": "string"
                  },
                  "memoryHistogram": {
                    "description": "Checkpoint of histogram for consumption of memory.",
                    "properties": {
                      "bucketWeights": {
                        "description": "Map from bucket index to bucket weight.",
                        "type": "object",
                        "x-kubernetes-preserve-unknown-fields": true
                      },
                      "referenceTimestamp": {
                        "description": "Reference timestamp for samples collected within this histogram.",
                        "format": "date-time",
                        "nullable": true,
                        "type": "string"
                      },
                      "totalWeight": {
                        "description": "Sum of samples to be used as denominator for weights from BucketWeights.",
                        "type": "number"
                      }
                    },
                    "type": "object"
                  },
                  "totalSamplesCount": {
                    "description": "Total number of samples in the histograms.",
                    "type": "integer"
                  },
                  "version": {
                    "description": "Version of the format of the stored data.",
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
      served  = true
      storage = false
    }
  }
}