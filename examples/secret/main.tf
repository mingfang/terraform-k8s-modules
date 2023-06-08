resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "secret" {
  source = "../../modules/kubernetes/secret"
  name = "test-secret"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    foo = base64encode("bar")
  }
}


