resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

// volume to store project files
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "openldap" {
  source    = "../../modules/openldap"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  LDAP_ORGANISATION = "rebelsoft"
  LDAP_DOMAIN       = "rebelsoft.com"

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

