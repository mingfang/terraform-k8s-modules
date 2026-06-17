//GENERATE DYNAMIC//k8s_networking_k8s_io_v1_ingress////
resource "k8s_networking_k8s_io_v1_ingress" "this" {


  metadata {
    annotations = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "annotations", null)
    labels      = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "labels", null)
    name        = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "name", null)
    namespace   = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "namespace", null)
  }

  spec {
    ingress_class_name = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "ingress_class", null)

    dynamic "rules" {
      for_each = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "rules", [])
      content {
        host = lookup(rules.value, "host", null)
        dynamic "http" {
          for_each = lookup(rules.value, "http", null) == null ? [] : [rules.value.http]
          content {
            dynamic "paths" {
              for_each = lookup(http.value, "paths", [])
              content {
                dynamic "backend" {
                  for_each = lookup(paths.value, "backend", null) == null ? [] : [paths.value.backend]
                  content {
                    service {
                      name = backend.value.service_name
                      port {
                        number = backend.value.service_port
                      }
                    }
                  }
                }
                path      = lookup(paths.value, "path", null)
                path_type = lookup(paths.value, "path_type", "ImplementationSpecific")
              }
            }
          }
        }
      }
    }

    dynamic "tls" {
      for_each = lookup(local.k8s_networking_k8s_io_v1_ingress_parameters, "tls", [])
      content {
        hosts       = contains(keys(tls.value), "hosts") ? tolist(tls.value.hosts) : null
        secret_name = lookup(tls.value, "secret_name", null)
      }
    }
  }

  lifecycle {

  }
}
