
# Module `aws/yandex-s3-csi/provisioner`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `command` (default `[]`)
* `csi_image` (default `"cr.yandex/crp9ftr22d26age3hulg/csi-s3:0.35.0"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"quay.io/k8scsi/csi-provisioner:v2.1.0"`)
* `image_pull_secrets` (default `[]`)
* `name` (default `"provisioner"`)
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

