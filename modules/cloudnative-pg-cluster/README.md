
# Module `cloudnative-pg-cluster`

**Prerequisite: Install CloudNativePG CRDs first.**

This module creates Kubernetes resources (Cluster, Pooler, ScheduledBackup) that depend on the CloudNativePG CRDs being already present in the cluster. The CRDs must be installed **before** this module can be applied, in a separate Terraform run or state, because the provider discovers CRD schemas at `init` time — not at `apply` time.

Install the CRDs with the `cloudnative-pg-crd` module first:

```hcl
module "cnpg_crd" {
  source = "./modules/cloudnative-pg-crd"
}
```

Then deploy clusters:

```hcl
module "cluster" {
  source   = "./modules/cloudnative-pg-cluster"
  name     = "my-postgres"
  namespace = "database"
  # ...
}
```

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `affinity` (default `{"enable_pod_anti_affinity":true,"node_selector":{"kubernetes.io/os":"linux"},"pod_anti_affinity_type":"preferred","topology_key":"kubernetes.io/hostname"}`): Affinity and node selector configuration for cluster pods.
* `barman_cloud` (default `{"data_compression":null,"data_encryption":null,"data_immediate_checkpoint":null,"data_jobs":null,"destination_path":null,"enabled":false,"endpoint_url":null,"inherit_from_iam_role":false,"name":null,"retention_policy":null,"s3_credentials_secret_name":null,"s3_region":null,"sidecar_retention_interval":1800,"sidecar_resources":{},"wal_compression":null,"wal_encryption":null,"wal_max_parallel":null}`): Barman Cloud Plugin configuration for WAL archiving and base backups to S3/S3-compatible object storage. Set enabled = true to activate. Requires destination_path, and s3_credentials_secret_name (or inherit_from_iam_role). All other fields are optional with sensible defaults.
* `barman_cloud_plugin_version` (default `"0.12.0"`): Version of the Barman Cloud CNPG-I plugin to install.
* `bootstrap` (default `{"database":"app","owner":"app"}`): Bootstrap configuration. Supports: database, owner, post_init_application_sql. When pooler is enabled, the module auto-appends schema grants and database grants to post_init_application_sql. postgresql_init_schemas is a separate variable for schema grants.
* `description` (default `null`): Description of this PostgreSQL cluster.
* `enable_replication_slots` (default `true`): Enable replication slots for high availability.
* `enable_superuser_access` (default `true`): When enabled, the operator creates a secret with superuser credentials.
* `env_map` (default `{}`): Environment map for passwords and other secrets.
* `image_name` (default `"ghcr.io/cloudnative-pg/postgresql:18.3-trixie"`): Container image name for the PostgreSQL database.
* `inherited_metadata` (default `{}`): Labels and annotations to be applied to all cluster resources.
* `instances` (default `3`): Number of instances in the cluster.
* `max_sync_replicas` (default `null`): Target value for synchronous replication quorum.
* `min_sync_replicas` (default `null`): Minimum number of instances required in synchronous replication.
* `monitoring` (default `null`): Monitoring configuration. Set to empty map {} to enable defaults.
* `monitoring_custom_queries` (default `{}`): Map of custom monitoring query config maps (name -> key).
* `name` (default `"cloudnative-pg-cluster"`): Name of the PostgreSQL cluster.
* `namespace` (default `"database"`): Kubernetes namespace for the cluster.
* `node_maintenance_window` (default `null`): Node maintenance window configuration.
* `password_secret_name` (default `null`): Existing secret name for superuser password. If null, a secret is auto-generated.
* `pooler` (default `{"instances":1,"max_client_conn":100,"name":null,"pg_hba":[],"pool_mode":"transaction"}`): PgBouncer pooler configuration. Set name to null to disable. pg_hba appends rules before the default scram-sha-256 rules.
* `postgresql_hba` (default `[]`): PostgreSQL pg_hba.conf rules (appended in USER-DEFINED section, before default scram-sha-256 rule).
* `postgresql_init_schemas` (default `[]`): List of schema names to automatically grant full access to the bootstrap owner (USAGE, CREATE, ALL TABLES/SEQUENCES, default privileges). Use this for extension schemas like 'bm25_catalog', 'tokenizer_catalog', etc.
* `postgresql_parameters` (default `{"checkpoint_completion_target":"0.9","default_statistics_target":"100","effective_cache_size":"1GB","effective_io_concurrency":"200","maintenance_work_mem":"64MB","max_connections":"200","max_replication_slots":"3","max_wal_senders":"3","random_page_cost":"1.1","shared_buffers":"256MB","wal_buffers":"-1","wal_keep_size":"1GB","wal_level":"replica","wal_log_hints":"on"}`): PostgreSQL configuration parameters (postgresql.conf).
* `postgresql_shared_preload_libraries` (default `["pg_stat_statements","pgaudit"]`): Shared preload libraries for PostgreSQL.
* `priority_class_name` (default `null`): Kubernetes priority class name for cluster pods.
* `resources` (default `{"limits":{"memory":"2Gi"},"requests":{"cpu":"500m","memory":"1Gi"}}`): Resource requests and limits for cluster pods.
* `scheduled_backup` (default `{"backup_owner_reference":"none","enabled":false,"immediate":false,"schedule":"0 0 0 * * *"}`): Scheduled backup configuration using the Barman Cloud Plugin. Set enabled = true to activate. Schedule uses cron expression with seconds (e.g., "0 0 0 * * *" for midnight daily).
* `service_account_name` (default `null`): Custom service account name for cluster pods.
* `storage_class` (default `null`): Storage class for the persistent volume. If null, uses the default.
* `storage_size` (default `"10Gi"`): Size of the persistent volume for PostgreSQL data.
* `tablespaces` (default `[]`): Tablespace configurations.
* `tolerations` (default `[]`): Kubernetes tolerations for cluster pods.

## Output Values
* `barman_object_store_name`: Name of the Barman Cloud ObjectStore resource. Only set when barman_cloud.enabled is true.
* `cluster_service_name`: Primary read-write service name for direct PostgreSQL connections.
* `name`: Name of the PostgreSQL cluster.
* `namespace`: Namespace of the PostgreSQL cluster.
* `password_secret_name`: Name of the password secret.
* `pooler_service_name`: PgBouncer pooler service name. Only set when pooler.name is provided.
* `primary_service_name`: Name of the primary service.
* `read_service_name`: Name of the read service.
* `scheduled_backup_name`: Name of the ScheduledBackup resource. Only set when scheduled_backup.enabled is true.

## Managed Resources
* `k8s_core_v1_secret.owner_password` from `k8s`
* `k8s_core_v1_secret.password` from `k8s`
* `k8s_postgresql_cnpg_io_v1_cluster.this` from `k8s`
* `k8s_postgresql_cnpg_io_v1_pooler.pooler` from `k8s`
* `k8s_postgresql_cnpg_io_v1_scheduled_backup.scheduled` from `k8s`
* `null_resource.barman_cloud_operator` from `null`

