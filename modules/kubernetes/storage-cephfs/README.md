
# Module `kubernetes/storage-cephfs`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `annotations` (default `{}`)
* `monitors` (required)
* `mount_options` (default `[]`)
* `name` (required)
* `namespace` (required)
* `path` (default `"/"`)
* `replicas` (required)
* `secret_name` (required)
* `secret_namespace` (required)
* `storage` (required)
* `user` (required)

## Output Values
* `replicas`
* `storage`
* `storage_class_name`

## Managed Resources
* `k8s_core_v1_persistent_volume.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`

