
# Module `openfaas/alertmanager`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `gateway_url` (required)
* `image` (default `"prom/alertmanager:v0.18.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9093}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"25Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

