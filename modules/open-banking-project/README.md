
# Module `open-banking-project`

Provider Requirements:
* **k8s:** (any version)
* **template:** (any version)

## Input Variables
* `OBP_AKKA_CONNECTOR_LOGLEVEL` (default `"INFO"`)
* `OBP_CONNECTOR` (default `null`)
* `OBP_DB_DRIVER` (default `null`)
* `OBP_DB_URL` (default `null`)
* `OBP_KAFKA_BOOTSTRAP_HOSTS` (default `null`)
* `OBP_KAFKA_CLIENT_ID` (default `null`)
* `OBP_KAFKA_PARTITIONS` (default `1`)
* `OBP_KAFKA_REQUEST_TOPIC` (default `"Request"`)
* `OBP_KAFKA_RESPONSE_TOPIC` (default `"Response"`)
* `OBP_LOGGER_LOGLEVEL` (default `"INFO"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/obp-base"`)
* `logback_xml_file` (default `""`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `name`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.config` from `template`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

