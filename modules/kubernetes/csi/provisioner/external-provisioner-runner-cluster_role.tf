resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "external-provisioner-runner" {
  metadata {
    name = "${var.name}-runner"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "persistentvolumes",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "persistentvolumeclaims",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "storage.k8s.io",
    ]
    resources = [
      "storageclasses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "list",
      "watch",
      "create",
      "update",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshots",
    ]
    verbs = [
      "get",
      "list",
    ]
  }
  rules {
    api_groups = [
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshotcontents",
    ]
    verbs = [
      "get",
      "list",
    ]
  }
  rules {
    api_groups = [
      "storage.k8s.io",
    ]
    resources = [
      "csinodes",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
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
      "list",
      "watch",
    ]
  }
}