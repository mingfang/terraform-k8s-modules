//GENERATE DYNAMIC//k8s_core_v1_service////
resource "k8s_core_v1_service" "this" {


  metadata {
    annotations = lookup(local.k8s_core_v1_service_parameters, "annotations", null)
    labels      = lookup(local.k8s_core_v1_service_parameters, "labels", null)
    name        = lookup(local.k8s_core_v1_service_parameters, "name", null)
    namespace   = lookup(local.k8s_core_v1_service_parameters, "namespace", null)
  }

  spec {
    cluster_ip                  = lookup(local.k8s_core_v1_service_parameters, "cluster_ip", null)
    external_ips                = contains(keys(local.k8s_core_v1_service_parameters), "external_ips") ? tolist(local.k8s_core_v1_service_parameters.external_ips) : null
    external_name               = lookup(local.k8s_core_v1_service_parameters, "external_name", null)
    external_traffic_policy     = lookup(local.k8s_core_v1_service_parameters, "external_traffic_policy", null)
    health_check_node_port      = lookup(local.k8s_core_v1_service_parameters, "health_check_node_port", null)
    load_balancer_ip            = lookup(local.k8s_core_v1_service_parameters, "load_balancer_ip", null)
    load_balancer_source_ranges = contains(keys(local.k8s_core_v1_service_parameters), "load_balancer_source_ranges") ? tolist(local.k8s_core_v1_service_parameters.load_balancer_source_ranges) : null

    dynamic "ports" {
      for_each = lookup(local.k8s_core_v1_service_parameters, "ports", [])
      content {
        name        = lookup(ports.value, "name", null)
        node_port   = lookup(ports.value, "node_port", null)
        port        = ports.value.port
        protocol    = lookup(ports.value, "protocol", null)
        target_port = lookup(ports.value, "target_port", null)
      }
    }
    publish_not_ready_addresses = lookup(local.k8s_core_v1_service_parameters, "publish_not_ready_addresses", null)
    selector                    = lookup(local.k8s_core_v1_service_parameters, "selector", null)
    session_affinity            = lookup(local.k8s_core_v1_service_parameters, "session_affinity", null)

    dynamic "session_affinity_config" {
      for_each = lookup(local.k8s_core_v1_service_parameters, "session_affinity_config", null) == null ? [] : [local.k8s_core_v1_service_parameters.session_affinity_config]
      content {
        dynamic "client_ip" {
          for_each = lookup(session_affinity_config.value, "client_ip", null) == null ? [] : [session_affinity_config.value.client_ip]
          content {
            timeout_seconds = lookup(client_ip.value, "timeout_seconds", null)
          }
        }
      }
    }
    type = lookup(local.k8s_core_v1_service_parameters, "type", null)
  }

  lifecycle {

  }
}

