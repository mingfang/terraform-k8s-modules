resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_cert_manager_io_v1alpha2_certificate" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    secret_name = var.name
    common_name = "${var.name}.${var.namespace}.svc"
    isca        = true
    issuer_ref {
      kind = "ClusterIssuer"
      name = "test-selfsigned"
    }
  }
}

data "k8s_core_v1_secret" "this" {
  metadata {
    name      = k8s_cert_manager_io_v1alpha2_certificate.this.spec[0].secret_name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}

data "template_file" "policy-main" {
  template = file("${path.module}/policies/main.rego")
}

data "template_file" "policy-mutating" {
  template = file("${path.module}/policies/mutating.rego")
}

resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      "openpolicyagent.org/policy" = "rego"
    }
  }

  data = {
    "main.rego"     = data.template_file.policy-main.rendered
    "mutating.rego" = data.template_file.policy-mutating.rendered
  }
}

module "opa" {
  source    = "../../modules/opa"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    checksum-main     = md5(data.template_file.policy-main.rendered)
    checksum-mutating = md5(data.template_file.policy-mutating.rendered)
  }

  secret_name         = k8s_cert_manager_io_v1alpha2_certificate.this.spec[0].secret_name
  policies_config_map = k8s_core_v1_config_map.this.metadata[0].name
}

// run after the cert has been created else the data will fail
resource "k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration" "this" {
  metadata {
    name      = "${var.name}.opa.org"
    namespace = var.namespace
  }

  webhooks {
    name = "${var.name}.opa.org"

    rules {
      api_groups   = [""]
      api_versions = ["v1"]
      operations   = ["CREATE", "UPDATE"]
      resources    = ["namespaces"]
    }

    client_config {
      cabundle = data.k8s_core_v1_secret.this.data["ca.crt"]

      service {
        name      = module.opa.name
        namespace = var.namespace
      }
    }

    admission_review_versions = ["v1"]
    failure_policy            = "Ignore"
    side_effects              = "None"
    timeout_seconds           = 5
  }
}


