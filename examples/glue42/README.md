
# Module `glue42`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"glue42"`)
* `namespace` (default `"glue42-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `glue42` from [../../modules/glue42](../../modules/glue42)

