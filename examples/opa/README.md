
# Module `opa`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `name` (default `"opa"`)
* `namespace` (default `"opa-example"`)

## Managed Resources
* `k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration.this` from `k8s`
* `k8s_cert_manager_io_v1alpha2_certificate.this` from `k8s`
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`

## Data Resources
* `data.k8s_core_v1_secret.this` from `k8s`
* `data.template_file.policy-main` from `template`
* `data.template_file.policy-mutating` from `template`

## Child Modules
* `opa` from [../../modules/opa](../../modules/opa)

