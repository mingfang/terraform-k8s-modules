resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "ebs_external_attacher_role" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name = "ebs-external-attacher-role"
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
      "update",
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
  rules {
    api_groups = [
      "csi.storage.k8s.io",
    ]
    resources = [
      "csinodeinfos",
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
      "volumeattachments",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
}