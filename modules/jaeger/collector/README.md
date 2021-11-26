
# Module `jaeger/collector`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_map_name` (required)
* `env` (default `[]`)
* `image` (default `"jaegertracing/jaeger-collector:1.20.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http-jaeger","port":14268},{"name":"http-admin","port":14269},{"name":"http-zipkin","port":9411},{"name":"grpc","port":14250}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

