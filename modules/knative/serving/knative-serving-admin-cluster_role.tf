resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "knative-serving-admin" {
  aggregation_rule {

    cluster_role_selectors {
      match_labels = {
        "serving.knative.dev/controller" = "true"
      }
    }
  }
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name = "knative-serving-admin"
  }

}