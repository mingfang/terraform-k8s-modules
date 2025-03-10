
# Module `mongodb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `MONGO_INITDB_DATABASE` (default `""`)
* `MONGO_INITDB_ROOT_PASSWORD` (default `""`)
* `MONGO_INITDB_ROOT_USERNAME` (default `""`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"mongo:5.0.6"`)
* `keyfile_secret` (required): secret with keyfile key, value must be base64 encoded
* `name` (required)
* `namespace` (required)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":27017}]`)
* `replica_set` (default `"rs0"`): replica set name
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"4Gi"},"requests":{"cpu":"250m","memory":"1Gi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `seed_list`
* `service`
* `statefulset`

## Child Modules
* `init-job` from [../kubernetes/job](../kubernetes/job)
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

