
# Module `weaviate/weaviate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED` (default `true`)
* `CONTEXTIONARY_URL` (default `null`)
* `DEFAULT_VECTORIZER_MODULE` (default `""`)
* `ENABLE_MODULES` (default `""`)
* `NER_INFERENCE_API` (default `null`)
* `PERSISTENCE_DATA_PATH` (default `"/data"`)
* `QNA_INFERENCE_API` (default `null`)
* `QUERY_DEFAULTS_LIMIT` (default `25`)
* `SPELLCHECK_INFERENCE_API` (default `null`)
* `TRANSFORMERS_INFERENCE_API` (default `null`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"semitechnologies/weaviate:1.12.2"`)
* `name` (required)
* `namespace` (required)
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

