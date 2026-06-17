
# Module `anteon`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"anteon"`)
* `namespace` (default `"anteon-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.anteon` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.anteon-api` from `k8s`

## Child Modules
* `alaz-agent` from [../../modules/generic-daemonset](../../modules/generic-daemonset)
* `alaz-backend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `alaz-backend-celery-beat` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `alaz-backend-celery-worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `alaz-backend-request-writer` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `anteon-frontend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `backend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `backend-celery-beat` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `backend-celery-worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hammer` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hammermanager` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hammermanager-celery-beat` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hammermanager-celery-worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `influxdb` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `prometheus` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `rabbitmq` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `redis-alaz-backend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `redis-backend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `seaweedfs` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

