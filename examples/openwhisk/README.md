
# Module `openwhisk`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"5VCTEQOQ0GR0NV1T67GN"`)
* `minio_secret_key` (default `"8MBK5aJTR330V1sohz4n1i7W5Wv/jzahARNHUzi3"`)
* `name` (default `"openwhisk"`)
* `namespace` (default `"openwhisk-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.control-center` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.nginx` from `k8s`

## Child Modules
* `admin` from [../../modules/openwhisk/admin](../../modules/openwhisk/admin)
* `apigateway` from [../../modules/openwhisk/apigateway](../../modules/openwhisk/apigateway)
* `control-center` from [../../modules/confluentinc/control-center](../../modules/confluentinc/control-center)
* `controller` from [../../modules/openwhisk/controller](../../modules/openwhisk/controller)
* `couchdb` from [../../modules/couchdb](../../modules/couchdb)
* `db-config` from [../../modules/openwhisk/db-config](../../modules/openwhisk/db-config)
* `db-secret` from [../../modules/openwhisk/db-secret](../../modules/openwhisk/db-secret)
* `init` from [../../modules/openwhisk/init](../../modules/openwhisk/init)
* `invoker` from [../../modules/openwhisk/invoker](../../modules/openwhisk/invoker)
* `kafka` from [../../modules/confluentinc/kafka](../../modules/confluentinc/kafka)
* `nginx` from [../../modules/openwhisk/nginx](../../modules/openwhisk/nginx)
* `redis` from [../../modules/redis](../../modules/redis)
* `schema-registry` from [../../modules/confluentinc/schema-registry](../../modules/confluentinc/schema-registry)
* `whisk-config` from [../../modules/openwhisk/whisk-config](../../modules/openwhisk/whisk-config)
* `whisk-secret` from [../../modules/openwhisk/whisk-secret](../../modules/openwhisk/whisk-secret)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

