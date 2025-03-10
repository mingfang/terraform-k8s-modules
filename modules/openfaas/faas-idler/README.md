
# Module `openfaas/faas-idler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `gateway_url` (required)
* `image` (default `"ghcr.io/openfaas/faas-idler-pro:0.4.4"`)
* `inactivity_duration` (default `"30m"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `prometheus_host` (required)
* `prometheus_port` (required)
* `reconcile_interval` (default `"2m"`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"64Mi"}}`)
* `write_debug` (default `true`)

## Output Values
* `deployment`
* `name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

