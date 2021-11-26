
# Module `weaviate/t2v-transformers`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ENABLE_CUDA` (default `"0"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"semitechnologies/transformers-inference:distilbert-base-uncased"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"1000m","memory":"3000Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

