
# Module `secret`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"secret"`)
* `namespace` (default `"secret-example"`)

## Output Values
* `secret_ref`
* `secret_ref_prefix`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

