
# Module `aws/aws-ebs-csi/storage-ebs`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `aws_ebs_volumes` (required): list of aws_ebs_volume
* `fstype` (default `"xfs"`)
* `name` (required)
* `namespace` (required)

## Output Values
* `name`
* `replicas`
* `storage`
* `storage_class_name`

## Managed Resources
* `k8s_core_v1_persistent_volume.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_storage_k8s_io_v1_storage_class.this` from `k8s`

