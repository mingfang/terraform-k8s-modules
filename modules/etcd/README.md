
# Module `etcd`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"gcr.io/etcd-development/etcd:v3.3.13"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"peer","port":2380},{"name":"client","port":2379}]`)
* `replicas` (default `3`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

