
# Module `varnish`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"varnish"`)
* `namespace` (default `"varnish-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `varnish` from [../../modules/varnish](../../modules/varnish)

