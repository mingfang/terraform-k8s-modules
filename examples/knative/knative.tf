module "knative-crd" {
  source = "./modules/knative/crd"
}

/*
resource "k8s_core_v1_namespace" "knative-serving" {
  metadata {
    labels = {
      "istio-injection"             = "false"
      "serving.knative.dev/release" = "devel"
    }
    name = "knative-serving"
  }
}

module "serving" {
  source = "./modules/knative/serving"
  namespace = k8s_core_v1_namespace.knative-serving.metadata[0].name
}
*/
