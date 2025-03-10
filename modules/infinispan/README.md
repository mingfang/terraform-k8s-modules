
# Module `infinispan`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PASS` (required)
* `USER` (required)
* `annotations` (default `{}`)
* `configmap` (default `null`): configmap containing infinispan.xml
* `env` (default `[]`)
* `image` (default `"quay.io/infinispan/server:11.0.9.Final"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":11222}]`)
* `replicas` (default `1`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

