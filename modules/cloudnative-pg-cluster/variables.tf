variable "name" {
  default     = "cloudnative-pg-cluster"
  description = "Name of the PostgreSQL cluster."
}

variable "namespace" {
  default     = "database"
  description = "Kubernetes namespace for the cluster."
}

variable "instances" {
  default     = 3
  description = "Number of instances in the cluster."
}

variable "description" {
  default     = null
  description = "Description of this PostgreSQL cluster."
}

variable "image_name" {
  default     = "ghcr.io/cloudnative-pg/postgresql:18.3-trixie"
  description = "Container image name for the PostgreSQL database."
}

variable "enable_superuser_access" {
  default     = true
  description = "When enabled, the operator creates a secret with superuser credentials."
}

# Storage
variable "storage_size" {
  default     = "10Gi"
  description = "Size of the persistent volume for PostgreSQL data."
}

variable "storage_class" {
  default     = null
  description = "Storage class for the persistent volume. If null, uses the default."
}

# Bootstrap
variable "bootstrap" {
  default = {
    database = "app"
    owner    = "app"
  }
  description = "Bootstrap configuration. Supports: database, owner, post_init_application_sql. When pooler is enabled, the module auto-appends schema grants and database grants to post_init_application_sql. postgresql_init_schemas is a separate variable for schema grants."
}

# Password
variable "password_secret_name" {
  default     = null
  description = "Existing secret name for superuser password. If null, a secret is auto-generated."
}

variable "env_map" {
  default     = {}
  description = "Environment map for passwords and other secrets."
}

# PostgreSQL configuration
variable "postgresql_parameters" {
  default = {
    max_connections              = "200"
    shared_buffers               = "256MB"
    effective_cache_size         = "1GB"
    maintenance_work_mem         = "64MB"
    checkpoint_completion_target = "0.9"
    wal_buffers                  = "-1"
    default_statistics_target    = "100"
    random_page_cost             = "1.1"
    effective_io_concurrency     = "200"
    wal_level                    = "replica"
    wal_keep_size                = "1GB"
    wal_log_hints                = "on"
    max_wal_senders              = "3"
    max_replication_slots        = "3"
  }
  description = "PostgreSQL configuration parameters (postgresql.conf)."
}

variable "postgresql_init_schemas" {
  default     = []
  description = "List of schema names to automatically grant full access to the bootstrap owner (USAGE, CREATE, ALL TABLES/SEQUENCES, default privileges). Use this for extension schemas like 'bm25_catalog', 'tokenizer_catalog', etc."
}

variable "postgresql_shared_preload_libraries" {
  default     = ["pg_stat_statements", "pgaudit"]
  description = "Shared preload libraries for PostgreSQL."
}

 variable "postgresql_hba" {
   default     = []
    description = "PostgreSQL pg_hba.conf rules (appended in USER-DEFINED section, before default scram-sha-256 rule)."
 }

# Monitoring
variable "monitoring" {
  default     = null
  description = "Monitoring configuration. Set to empty map {} to enable defaults."
}

variable "monitoring_custom_queries" {
  default     = {}
  description = "Map of custom monitoring query config maps (name -> key)."
}

# Inherited metadata
variable "inherited_metadata" {
  default     = {}
  description = "Labels and annotations to be applied to all cluster resources."
}

# Replication
variable "enable_replication_slots" {
  default     = true
  description = "Enable replication slots for high availability."
}

variable "max_sync_replicas" {
  default     = null
  description = "Target value for synchronous replication quorum."
}

variable "min_sync_replicas" {
  default     = null
  description = "Minimum number of instances required in synchronous replication."
}

# Pooler (PgBouncer)
variable "pooler" {
  type = object({
    name            = string
    max_client_conn = number
    pool_mode       = string
    instances       = number
    pg_hba          = list(string)
  })
  default = {
    name            = null
    max_client_conn = 100
    pool_mode       = "transaction"
    instances       = 1
    pg_hba          = []
  }
  description = "PgBouncer pooler configuration. Set name to null to disable. pg_hba appends rules before the default scram-sha-256 rules."
}

# Affinity
variable "affinity" {
  type = object({
    enable_pod_anti_affinity = bool
    pod_anti_affinity_type   = string
    topology_key             = string
    node_selector            = map(string)
  })
  default = {
    enable_pod_anti_affinity = true
    pod_anti_affinity_type   = "preferred"
    topology_key             = "kubernetes.io/hostname"
    node_selector = {
      "kubernetes.io/os" = "linux"
    }
  }
  description = "Affinity and node selector configuration for cluster pods."
}

# Resource limits
variable "resources" {
  default = {
    requests = { cpu = "500m", memory = "1Gi" }
    limits   = { memory = "2Gi" }
  }
  description = "Resource requests and limits for cluster pods."
}

# Tolerations
variable "tolerations" {
  default     = []
  description = "Kubernetes tolerations for cluster pods."
}

# Priority class
variable "priority_class_name" {
  default     = null
  description = "Kubernetes priority class name for cluster pods."
}

# Service account
variable "service_account_name" {
  default     = null
  description = "Custom service account name for cluster pods."
}

# Node maintenance window
variable "node_maintenance_window" {
  default     = null
  description = "Node maintenance window configuration."
}

# Tablespaces
variable "tablespaces" {
  default     = []
  description = "Tablespace configurations."
}
