
# Module `openfaas/queue-worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ack_wait` (default `"60s"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `faas_function_suffix` (default `null`): default to <function_namespace>.svc.cluster.local
* `faas_gateway_address` (required)
* `faas_nats_address` (default `""`)
* `faas_nats_channel` (default `""`)
* `faas_nats_cluster_name` (default `""`)
* `faas_nats_port` (default `""`)
* `faas_nats_queue_group` (default `"faas"`)
* `function_namespace` (default `null`): default to same namespace as gateway
* `gateway_invoke` (default `true`)
* `image` (default `"ghcr.io/openfaas/queue-worker:0.12.2"`)
* `max_inflight` (default `1`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"120Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

