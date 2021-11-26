
# Module `zeebe/operate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CAMUNDA_OPERATE_ELASTICSEARCH_HOST` (required)
* `CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST` (required)
* `CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT` (required)
* `image` (default `"camunda/operate:0.23.2"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

