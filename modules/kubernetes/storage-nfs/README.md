
# Module `kubernetes/storage-nfs`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `annotations` (default `{}`)
* `mount_options` (default `[]`)
* `name` (required)
* `namespace` (required)
* `nfs_server` (required)
* `replicas` (required)
* `storage` (required)

## Output Values
* `replicas`
* `storage`
* `storage_class_name`

## Managed Resources
* `k8s_core_v1_persistent_volume.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`

