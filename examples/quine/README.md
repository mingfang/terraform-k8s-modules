
# Module `quine`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"quine"`)
* `namespace` (default `"quine-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `cassandra` from [../../modules/cassandra](../../modules/cassandra)
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `quine` from [../../modules/quine](../../modules/quine)

