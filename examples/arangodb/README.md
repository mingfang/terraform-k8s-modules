
# Module `arangodb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"arangodb"`)
* `namespace` (default `"arangodb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `agency` from [../../modules/arangodb/agency](../../modules/arangodb/agency)
* `coordinator` from [../../modules/arangodb/coordinator](../../modules/arangodb/coordinator)
* `dbserver` from [../../modules/arangodb/dbserver](../../modules/arangodb/dbserver)
* `jwt-secret-file` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

