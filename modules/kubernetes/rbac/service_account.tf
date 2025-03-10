//GENERATE DYNAMIC//k8s_core_v1_service_account////
resource "k8s_core_v1_service_account" "this" {


  automount_service_account_token = lookup(local.k8s_core_v1_service_account_parameters, "automount_service_account_token", null)

  dynamic "image_pull_secrets" {
    for_each = lookup(local.k8s_core_v1_service_account_parameters, "image_pull_secrets", [])
    content {
      name = lookup(image_pull_secrets.value, "name", null)
    }
  }

  metadata {
    annotations = lookup(local.k8s_core_v1_service_account_parameters, "annotations", null)
    labels      = lookup(local.k8s_core_v1_service_account_parameters, "labels", null)
    name        = lookup(local.k8s_core_v1_service_account_parameters, "name", null)
    namespace   = lookup(local.k8s_core_v1_service_account_parameters, "namespace", null)
  }

  dynamic "secrets" {
    for_each = lookup(local.k8s_core_v1_service_account_parameters, "secrets", [])
    content {
      api_version      = lookup(secrets.value, "api_version", null)
      field_path       = lookup(secrets.value, "field_path", null)
      kind             = lookup(secrets.value, "kind", null)
      name             = lookup(secrets.value, "name", null)
      namespace        = lookup(secrets.value, "namespace", null)
      resource_version = lookup(secrets.value, "resource_version", null)
      uid              = lookup(secrets.value, "uid", null)
    }
  }

  lifecycle {

  }
}

