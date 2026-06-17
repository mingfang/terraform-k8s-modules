
# Module `activepieces`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AP_ENCRYPTION_KEY` (required): 256-bit encryption key, must be a 32-character hex string. Generate with: openssl rand -hex 16
* `AP_JWT_SECRET` (required): JWT secret for signing tokens, must be a 64-character hex string. Generate with: openssl rand -hex 32
* `AP_POSTGRES_DATABASE` (default `"activepieces"`)
* `AP_POSTGRES_PASSWORD` (default `"activepieces"`)
* `AP_POSTGRES_USERNAME` (default `"postgres"`)
* `AP_WORKER_TOKEN` (required): JWT token for worker authentication. Generated with AP_JWT_SECRET.
* `is_create_namespace` (default `true`)
* `name` (default `"activepieces"`)
* `namespace` (default `"activepieces-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.app` from `k8s`

## Child Modules
* `app` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `worker` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

