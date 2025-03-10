
# Module `aws/yandex-s3-csi/attacher`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `command` (default `[]`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"quay.io/k8scsi/csi-attacher:v3.0.1"`)
* `image_pull_secrets` (default `[]`)
* `name` (default `"attacher"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `post_start_command` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `name`
* `service`
* `statefulset`

## Child Modules
* `rbac` from [../../../../modules/kubernetes/rbac](../../../../modules/kubernetes/rbac)
* `statefulset-service` from [../../../../archetypes/statefulset-service](../../../../archetypes/statefulset-service)

