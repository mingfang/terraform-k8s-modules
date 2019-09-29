resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "istio-ingressgateway-sds" {
  metadata {
    name      = "istio-ingressgateway-sds"
    namespace = "${var.namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "istio-ingressgateway-sds"
  }

  subjects {
    kind = "ServiceAccount"
    name = "istio-ingressgateway-service-account"
  }
}