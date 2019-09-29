/**
 * Example CustomResourceDefinition
 * https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/
 */
resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "crontabs_stable_example_com" {
  metadata {
    annotations = {
      "kubectl.kubernetes.io/last-applied-configuration" = <<-EOF
        {"apiVersion":"apiextensions.k8s.io/v1beta1","kind":"CustomResourceDefinition","metadata":{"annotations":{},"name":"crontabs.stable.example.com"},"spec":{"group":"stable.example.com","names":{"kind":"CronTab","plural":"crontabs","shortNames":["ct"],"singular":"crontab"},"preserveUnknownFields":false,"scope":"Namespaced","validation":{"openAPIV3Schema":{"properties":{"spec":{"properties":{"cronSpec":{"type":"string"},"image":{"type":"string"},"replicas":{"type":"integer"}},"type":"object"}},"type":"object"}},"versions":[{"name":"v1","served":true,"storage":true}]}}
        
        EOF
    }
    name = "crontabs.stable.example.com"
  }
  spec {
    conversion {
      strategy = "None"
    }
    group = "stable.example.com"
    names {
      kind      = "CronTab"
      list_kind = "CronTabList"
      plural    = "crontabs"
      short_names = [
        "ct",
      ]
      singular = "crontab"
    }
    preserve_unknown_fields = false
    scope                   = "Namespaced"
    validation {
      open_apiv3_schema = <<-JSON
        {
          "properties": {
            "spec": {
              "properties": {
                "cronSpec": {
                  "type": "string"
                },
                "image": {
                  "type": "string"
                },
                "replicas": {
                  "type": "integer"
                }
              },
              "type": "object"
            }
          },
          "type": "object"
        }
        JSON
    }
    version = "v1"

    versions {
      name    = "v1"
      served  = true
      storage = true
    }
  }
}
