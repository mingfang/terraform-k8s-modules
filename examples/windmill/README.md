
# Module `windmill`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"windmill"`)
* `namespace` (default `"windmill-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `windmill-lsp` from [../../modules/windmill/lsp](../../modules/windmill/lsp)
* `windmill-server` from [../../modules/windmill/server](../../modules/windmill/server)
* `windmill-worker` from [../../modules/windmill/worker](../../modules/windmill/worker)

