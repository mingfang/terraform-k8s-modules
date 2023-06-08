
# Module `httpbin`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"httpbin"`)
* `namespace` (default `"httpbin-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_limit_range.this` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `httpbin` from [../../modules/httpbin](../../modules/httpbin)

