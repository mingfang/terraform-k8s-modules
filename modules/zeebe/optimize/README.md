
# Module `zeebe/optimize`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CAMUNDA_OPTIMIZE_ELASTICSEARCH_URL` (required)
* `CAMUNDA_OPTIMIZE_ZEEBEELASTICSEARCH_URL` (required)
* `CAMUNDA_OPTIMIZE_ZEEBE_GATEWAYADDRESS` (required)
* `image` (default `"camunda/optimize:1.3.3"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8090}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

