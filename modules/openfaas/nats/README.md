
# Module `openfaas/nats`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `cluster_id` (required)
* `env` (default `[]`)
* `image` (default `"nats-streaming:0.17.0"`)
* `metrics_image` (default `"synadia/prometheus-nats-exporter:0.6.2"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"client","port":4222},{"name":"monitoring","port":8222},{"name":"metrics","port":7777}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"120Mi"}}`)

## Output Values
* `cluster_id`
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

