
# Module `cadence/server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `CADENCE_CLI_DOMAIN` (default `"default"`)
* `CADENCE_CLI_SHOW_STACKS` (default `"1"`)
* `CASSANDRA_CONSISTENCY` (default `"One"`)
* `CASSANDRA_SEEDS` (required)
* `ES_SEEDS` (default `""`)
* `FRONTEND` (default `"127.0.0.1"`)
* `KAFKA_SEEDS` (default `""`)
* `LOG_LEVEL` (default `"info"`)
* `NUM_HISTORY_SHARDS` (default `512`)
* `RINGPOP_SEEDS` (default `""`)
* `SERVICES` (default `"history,matching,frontend,worker"`)
* `SKIP_SCHEMA_SETUP` (default `false`)
* `STATSD_ENDPOINT` (default `""`)
* `annotations` (default `{}`)
* `config_file` (default `""`)
* `env` (default `[]`)
* `image` (default `"ubercadence/server:0.10.3-auto-setup"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"frontend","port":7933},{"name":"history","port":7934},{"name":"matching","port":7935},{"name":"worker","port":7939}]`)
* `replicas` (default `1`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.config` from `template`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

