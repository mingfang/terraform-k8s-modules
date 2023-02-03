
# Module `aws/yandex-s3-csi/csi-s3`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"cr.yandex/crp9ftr22d26age3hulg/csi-s3:0.34.4"`)
* `image_pull_secrets` (default `[]`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"csi-s3"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `post_start_command` (default `[]`)
* `pvc` (default `null`)
* `registrar_image` (default `"quay.io/k8scsi/csi-node-driver-registrar:v1.2.0"`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from [../../../../archetypes/daemonset](../../../../archetypes/daemonset)
* `rbac` from [../../../../modules/kubernetes/rbac](../../../../modules/kubernetes/rbac)

