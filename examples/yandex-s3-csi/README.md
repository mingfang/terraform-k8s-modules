
# Module `yandex-s3-csi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AWS_ACCESS_KEY_ID` (required)
* `AWS_SECRET_ACCESS_KEY` (required)
* `name` (default `"yandex-s3-csi"`)
* `namespace` (default `"yandex-s3-csi-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume.s3` from `k8s`
* `k8s_core_v1_persistent_volume_claim.s3` from `k8s`

## Child Modules
* `attacher` from [../../modules/aws/yandex-s3-csi/attacher](../../modules/aws/yandex-s3-csi/attacher)
* `csi-s3` from [../../modules/aws/yandex-s3-csi/csi-s3](../../modules/aws/yandex-s3-csi/csi-s3)
* `provisioner` from [../../modules/aws/yandex-s3-csi/provisioner](../../modules/aws/yandex-s3-csi/provisioner)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `storage-class` from [../../modules/aws/yandex-s3-csi/storage-class](../../modules/aws/yandex-s3-csi/storage-class)
* `test` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

