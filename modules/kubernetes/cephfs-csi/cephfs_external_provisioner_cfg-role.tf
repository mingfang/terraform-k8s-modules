resource "k8s_rbac_authorization_k8s_io_v1_role" "cephfs_external_provisioner_cfg" {
  metadata {
    name      = "cephfs-external-provisioner-cfg"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "coordination.k8s.io",
    ]
    resources = [
      "leases",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "delete",
      "update",
      "create",
    ]
  }
}