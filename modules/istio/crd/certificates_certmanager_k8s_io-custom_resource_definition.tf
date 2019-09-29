resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificates_certmanager_k8s_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "certmanager"
      "chart"    = "certmanager"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "certificates.certmanager.k8s.io"
  }
  spec {

    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].status
        EOF
      name = "Ready"
      type = "string"
    }
    additional_printer_columns {
      json_path = ".spec.secretName"
      name = "Secret"
      type = "string"
    }
    additional_printer_columns {
      json_path = ".spec.issuerRef.name"
      name = "Issuer"
      priority = 1
      type = "string"
    }
    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].message
        EOF
      name     = "Status"
      priority = 1
      type     = "string"
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
    group = "certmanager.k8s.io"
    names {
      kind = "Certificate"
      plural = "certificates"
      short_names = [
        "cert",
        "certs",
      ]
    }
    scope = "Namespaced"
    version = "v1alpha1"
  }
}