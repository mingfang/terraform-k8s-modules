
# Module `qdrant`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"qdrant-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `qdrant` from [../../modules/qdrant](../../modules/qdrant)

