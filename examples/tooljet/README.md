
# Module `tooljet`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **random:** (any version)

## Input Variables
* `name` (default `"tooljet"`)
* `namespace` (default `"tooljet-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.tooljet` from `k8s`
* `random_password.LOCKBOX_MASTER_KEY` from `random`
* `random_password.SECRET_KEY_BASE` from `random`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `tooljet-client` from [../../modules/tooljet/client](../../modules/tooljet/client)
* `tooljet-server` from [../../modules/tooljet/server](../../modules/tooljet/server)

