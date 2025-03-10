
# Module `goldilocks`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"goldilocks"`)
* `namespace` (default `"goldilocks-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `goldilocks-controller` from [../../modules/goldilocks/controller](../../modules/goldilocks/controller)
* `goldilocks-dashboard` from [../../modules/goldilocks/dashboard](../../modules/goldilocks/dashboard)
* `vpa-recommender` from [../../modules/kubernetes/vpa-recommender](../../modules/kubernetes/vpa-recommender)

