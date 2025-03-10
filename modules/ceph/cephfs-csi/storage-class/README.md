
# Module `ceph/cephfs-csi/storage-class`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_provisioner` (required)
* `alluxio_path` (default `null`)
* `domain_socket` (default `null`)
* `java_options` (default `null`)
* `master_hostname` (required)
* `master_port` (required)
* `mount_options` (default `null`)
* `name` (required)

## Output Values
* `name`

## Managed Resources
* `k8s_storage_k8s_io_v1_storage_class.this` from `k8s`

