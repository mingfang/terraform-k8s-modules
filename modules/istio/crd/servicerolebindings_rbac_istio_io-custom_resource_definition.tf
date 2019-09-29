resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "servicerolebindings_rbac_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "rbac"
      "package"  = "istio.io.mixer"
      "release"  = "istio"
    }
    name = "servicerolebindings.rbac.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.roleRef.name"
      description = "The name of the ServiceRole object being referenced"
      name        = "Reference"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = <<-EOF
        CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
        
        Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
        EOF
      name = "Age"
      type = "date"
    }
    group = "rbac.istio.io"
    names {
      categories = [
        "istio-io",
        "rbac-istio-io",
      ]
      kind = "ServiceRoleBinding"
      plural = "servicerolebindings"
      singular = "servicerolebinding"
    }
    scope = "Namespaced"
    version = "v1alpha1"
  }
}