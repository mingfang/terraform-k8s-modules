
# Module `vald`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"vald-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.gateway` from `k8s`

## Child Modules
* `agent` from [../../modules/vald/agent](../../modules/vald/agent)
* `config_agent` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_discoverer` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_gateway` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_index` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `discoverer` from [../../modules/vald/discoverer](../../modules/vald/discoverer)
* `gateway` from [../../modules/vald/gateway](../../modules/vald/gateway)
* `index` from [../../modules/vald/index](../../modules/vald/index)

