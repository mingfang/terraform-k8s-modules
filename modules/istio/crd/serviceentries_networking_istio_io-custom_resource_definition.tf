resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "serviceentries_networking_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "serviceentries.networking.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.hosts"
      description = "The hosts associated with the ServiceEntry"
      name        = "Hosts"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.location"
      description = "Whether the service is external to the mesh or part of the mesh (MESH_EXTERNAL or MESH_INTERNAL)"
      name        = "Location"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.resolution"
      description = "Service discovery mode for the hosts (NONE, STATIC, or DNS)"
      name        = "Resolution"
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
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind = "ServiceEntry"
      list_kind = "ServiceEntryList"
      plural = "serviceentries"
      short_names = [
        "se",
      ]
      singular = "serviceentry"
    }
    scope = "Namespaced"
    version = "v1alpha3"
  }
}