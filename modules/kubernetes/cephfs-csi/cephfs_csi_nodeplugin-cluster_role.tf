resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cephfs_csi_nodeplugin" {
  metadata {
    name = "cephfs-csi-nodeplugin"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "nodes",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "get",
    ]
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
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "serviceaccounts",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "serviceaccounts/token",
    ]
    verbs = [
      "create",
    ]
  }
}