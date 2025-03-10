
# Module `hadoop`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"hadoop"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `master` from [../../modules/hadoop/master](../../modules/hadoop/master)
* `nodes` from [../../modules/hadoop/node](../../modules/hadoop/node)

