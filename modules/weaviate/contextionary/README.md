
# Module `weaviate/contextionary`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ENABLE_COMPOUND_SPLITTING` (default `false`)
* `EXTENSIONS_STORAGE_MODE` (default `"weaviate"`)
* `EXTENSIONS_STORAGE_ORIGIN` (required)
* `NEIGHBOR_OCCURRENCE_IGNORE_PERCENTILE` (default `5`)
* `OCCURRENCE_WEIGHT_LINEAR_FACTOR` (default `0.75`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"semitechnologies/contextionary:en0.16.0-v1.0.2"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9999}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"500Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

