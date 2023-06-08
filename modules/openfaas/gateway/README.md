
# Module `openfaas/gateway`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `direct_functions` (default `true`)
* `direct_functions_suffix` (default `null`): default to <function_namespace>.svc.cluster.local
* `env` (default `[]`)
* `faas_nats_address` (default `""`)
* `faas_nats_channel` (default `""`)
* `faas_nats_cluster_name` (default `""`)
* `faas_nats_port` (default `""`)
* `function_namespace` (default `null`): default to same namespace as gateway
* `functions_provider_url` (required)
* `image` (default `"ghcr.io/openfaas/gateway:0.21.3"`)
* `max_idle_conns` (default `1024`)
* `max_idle_conns_per_host` (default `1024`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `read_timeout` (default `"65s"`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"120Mi"}}`)
* `scale_from_zero` (default `true`)
* `upstream_timeout` (default `"60s"`): Must be smaller than read/write_timeout
* `write_timeout` (default `"65s"`)

## Output Values
* `deployment`
* `name`
* `service`
* `service_account_name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

