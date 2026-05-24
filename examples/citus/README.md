
# Module `citus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"registry.rebelsoft.com/postgres-vectorchord:18.3-trixie"`)
* `is_create_namespace` (default `true`)
* `name` (default `"citus"`)
* `namespace` (default `"citus-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Automatic Worker Registration

When a worker pod starts, a Kubernetes [lifecycle post_start hook](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) runs automatically and performs two steps:

1. **`CREATE EXTENSION IF NOT EXISTS citus;`** — initializes the Citus extension on the worker using `psql --username=postgres` (local trust auth). The `pg_isready` wait loop ensures postgres is accepting connections before executing.

2. **`SELECT * FROM master_add_node(...)`** — connects to the coordinator to self-register. It uses the worker's own DNS name (via the `HOSTNAME` env var set to `metadata.name`) and the namespace's FQDN to tell the coordinator about itself:

   ```
   SELECT * FROM master_add_node(
     '$HOSTNAME.worker.<namespace>.svc.cluster.local', 5432
   );
   ```

The coordinator must already have `CREATE EXTENSION citus` and `pg_dist_authinfo` populated (done by the coordinator's own post_start hook) before workers can join — this is why the coordinator pod starts first.

Once registered, the worker appears in `pg_dist_node` on the coordinator as an active node.

## Child Modules
* `coordinator` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `namespace` from [../namespace](../namespace)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `worker` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

