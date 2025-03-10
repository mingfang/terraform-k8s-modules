
# Module `aws/yandex-s3-csi/storage-class`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `bucket` (default `null`)
* `name` (default `"s3fs"`)
* `namespace` (required)
* `secret_name` (required): accessKeyID=YOUR_ACCESS_KEY_ID, secretAccessKey=YOUR_SECRET_ACCESS_KEY, endpoint="https://s3.<region>.amazonaws.com"

## Managed Resources
* `k8s_storage_k8s_io_v1_storage_class.this` from `k8s`

