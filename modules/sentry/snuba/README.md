
# Module `sentry/snuba`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CLICKHOUSE_HOST` (required)
* `DEFAULT_BROKERS` (required): Kafka URL, e.g. kafka:9092
* `REDIS_HOST` (required)
* `SNUBA_SETTINGS` (default `"docker"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"getsentry/snuba:a5074a3687de7a280d1ba66db70dc9e59d1b5057"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":1218}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

