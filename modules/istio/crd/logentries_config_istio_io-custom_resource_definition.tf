resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "logentries_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-instance"
      "package"  = "logentry"
      "release"  = "istio"
    }
    name = "logentries.config.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.severity"
      description = "The importance of the log entry"
      name        = "Severity"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.timestamp"
      description = "The time value for the log entry"
      name        = "Timestamp"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.monitored_resource_type"
      description = "Optional expression to compute the type of the monitored resource this log entry is being recorded on"
      name        = "Res Type"
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
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind = "logentry"
      plural = "logentries"
      singular = "logentry"
    }
    scope = "Namespaced"
    version = "v1alpha2"
  }
}