
# Module `weave-scope`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"weave-scope"`)
* `namespace` (default `"weave-scope-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.app` from `k8s`

## Child Modules
* `agent` from [../../modules/weave-scope/agent](../../modules/weave-scope/agent)
* `app` from [../../modules/weave-scope/app](../../modules/weave-scope/app)
* `cluster-agent` from [../../modules/weave-scope/cluster-agent](../../modules/weave-scope/cluster-agent)

