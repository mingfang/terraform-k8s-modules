
# Module `weaviate/weaviate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED` (default `true`)
* `DEFAULT_VECTORIZER_MODULE` (default `""`)
* `ENABLE_MODULES` (default `""`)
* `LOG_LEVEL` (default `"info"`)
* `PERSISTENCE_DATA_PATH` (default `"/data"`)
* `QUERY_DEFAULTS_LIMIT` (default `100`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_map` (default `{}`)
* `image` (default `"semitechnologies/weaviate:1.15.3"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"300Mi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

