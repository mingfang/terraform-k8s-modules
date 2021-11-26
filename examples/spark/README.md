
# Module `spark`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ingress_ip` (default `"192.168.2.146"`)
* `ingress_node_port` (default `"30080"`)
* `name` (default `"spark"`)
* `namespace` (default `"spark"`)

## Output Values
* `urls`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`

## Child Modules
* `ingress-rules` from [../../modules/kubernetes/ingress-rules](../../modules/kubernetes/ingress-rules)
* `master` from [../../modules/spark/master](../../modules/spark/master)
* `ui-proxy` from [../../modules/spark/ui-proxy](../../modules/spark/ui-proxy)
* `worker` from [../../modules/spark/worker](../../modules/spark/worker)

