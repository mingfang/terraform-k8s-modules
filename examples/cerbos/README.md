
# Module `cerbos`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **random:** (any version)

## Input Variables
* `namespace` (default `"cerbos-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.cerbos` from `k8s`
* `random_password.cerbos` from `random`

## Child Modules
* `cerbos` from [../../modules/cerbos](../../modules/cerbos)
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgres-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

