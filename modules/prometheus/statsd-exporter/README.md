
# Module `prometheus/statsd-exporter`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `image` (default `"prom/statsd-exporter:v0.12.2"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9102},{"name":"statsd-tcp","port":9125,"protocol":"TCP"},{"name":"statsd-udp","port":9125,"protocol":"UDP"}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

