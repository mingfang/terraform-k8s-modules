module "example-user-code" {
  source    = "./example-user-code"
  name      = "example-user-code"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}
