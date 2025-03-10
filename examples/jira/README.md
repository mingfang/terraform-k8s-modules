
# Module `jira`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"jira"`)
* `namespace` (default `"jira-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.shared` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `jira` from [../../modules/jira](../../modules/jira)
* `postgres` from [../../modules/postgres](../../modules/postgres)

