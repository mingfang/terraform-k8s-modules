resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cephfs_external_provisioner_runner" {
  metadata {
    name = "cephfs-external-provisioner-runner"
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
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
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
      "update",
      "delete",
      "patch",
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
      "",
    ]
    resources = [
      "persistentvolumeclaims/status",
    ]
    verbs = [
      "update",
      "patch",
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
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshots",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
      "patch",
      "create",
    ]
  }
  rules {
    api_groups = [
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshots/status",
    ]
    verbs = [
      "get",
      "list",
      "patch",
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
      "watch",
      "update",
      "patch",
      "create",
    ]
  }
  rules {
    api_groups = [
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshotclasses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
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
      "snapshot.storage.k8s.io",
    ]
    resources = [
      "volumesnapshotcontents/status",
    ]
    verbs = [
      "update",
      "patch",
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
  rules {
    api_groups = [
      "groupsnapshot.storage.k8s.io",
    ]
    resources = [
      "volumegroupsnapshotclasses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "groupsnapshot.storage.k8s.io",
    ]
    resources = [
      "volumegroupsnapshotcontents",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "groupsnapshot.storage.k8s.io",
    ]
    resources = [
      "volumegroupsnapshotcontents/status",
    ]
    verbs = [
      "update",
      "patch",
    ]
  }
}