
resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "nuclioapigateways" {
  metadata {
    name = "nuclioapigateways.nuclio.io"
  }

  spec {
    group   = "nuclio.io"
    scope = "Namespaced"
    names {
      kind      = "NuclioAPIGateway"
      plural    = "nuclioapigateways"
      singular  = "nuclioapigateway"
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = true
      schema {
        open_apiv3_schema = <<-JSON
        {
          "type": "object",
          "properties": {
             "spec": {
                "x-kubernetes-preserve-unknown-fields": true
             },
             "status": {
                "x-kubernetes-preserve-unknown-fields": true
             }
          }
        }
        JSON
      }
    }
  }
}

resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "nucliofunctionevents" {
  metadata {
    name = "nucliofunctionevents.nuclio.io"
  }

  spec {
    group   = "nuclio.io"
    scope = "Namespaced"
    names {
      kind      = "NuclioFunctionEvent"
      plural    = "nucliofunctionevents"
      singular  = "nucliofunctionevent"
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = true
      schema {
        open_apiv3_schema = <<-JSON
        {
          "type": "object",
          "properties": {
             "spec": {
                "x-kubernetes-preserve-unknown-fields": true
             },
             "status": {
                "x-kubernetes-preserve-unknown-fields": true
             }
          }
        }
        JSON
      }
    }
  }
}

resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "nucliofunctions" {
  metadata {
    name = "nucliofunctions.nuclio.io"
  }

  spec {
    group   = "nuclio.io"
    scope = "Namespaced"
    names {
      kind      = "NuclioFunction"
      plural    = "nucliofunctions"
      singular  = "nucliofunction"
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = true
      schema {
        open_apiv3_schema = <<-JSON
        {
          "type": "object",
          "properties": {
             "spec": {
                "x-kubernetes-preserve-unknown-fields": true
             },
             "status": {
                "x-kubernetes-preserve-unknown-fields": true
             }
          }
        }
        JSON
      }
    }
  }
}

resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "nuclioprojects" {
  metadata {
    name = "nuclioprojects.nuclio.io"
  }

  spec {
    group   = "nuclio.io"
    scope = "Namespaced"
    names {
      kind      = "NuclioProject"
      plural    = "nuclioprojects"
      singular  = "nuclioproject"
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = true
      schema {
        open_apiv3_schema = <<-JSON
        {
          "type": "object",
          "properties": {
             "spec": {
                "x-kubernetes-preserve-unknown-fields": true
             },
             "status": {
                "x-kubernetes-preserve-unknown-fields": true
             }
          }
        }
        JSON
      }
    }
  }
}
