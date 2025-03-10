
# Module `goldpinger`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"goldpinger"`)
* `namespace` (default `"goldpinger-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `goldpinger` from [../../modules/goldpinger](../../modules/goldpinger)

