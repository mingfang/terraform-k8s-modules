resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "knative-serving-build" {
  metadata {
    labels = {
      "serving.knative.dev/controller" = "true"
      "serving.knative.dev/release"    = "devel"
    }
    name = "knative-serving-build"
  }

  rules {
    api_groups = [
      "build.knative.dev",
    ]
    resources = [
      "builds",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
}