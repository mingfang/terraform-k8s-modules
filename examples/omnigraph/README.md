
# Module `omnigraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"omnigraph"`) — Name of the omnigraph deployment
* `namespace` (default `"omnigraph-example"`) — Kubernetes namespace
* `image` (default `"ghcr.io/modernrelay/omnigraph-server:latest"`) — Container image
* `bearer_token` (default `"change-me"`) — Bearer token for Omnigraph server authentication
* `s3_bucket` (default `"omnigraph-local"`) — S3 bucket name for Omnigraph graph storage
* `graph_name` (default `"example"`) — Graph name within the S3 bucket
* `rustfs_access_key` (default `"omnigraph"`) — RustFS access key
* `rustfs_secret_key` (default `"omnigraph"`) — RustFS secret key
* `rustfs_storage` (default `"10Gi"`) — RustFS persistent volume size
* `aws_region` (default `"us-east-1"`) — AWS region for S3 access
* `is_create_namespace` (default `true`) — Whether to create the namespace
* `config_git_repo` (default `"https://github.com/mingfang/omnigraph-example.git"`) — Git repo with config files
* `config_git_branch` (default `"main"`) — Git branch to clone
* `config_git_poll_interval` (default `300`) — Git poll interval in seconds for the sidecar
* `git_auth_token` — GitHub PAT for private repos (set in `.auto.tfvars`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.rustfs-data` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.omnigraph` from `k8s`

## Child Modules
* `rustfs` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `omnigraph` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

## Overview

This example deploys [Omnigraph](https://www.omnigraph.dev) — a lakehouse-native graph engine — alongside [RustFS](https://github.com/ModernRelay/rustfs) as a local S3-compatible storage backend. This setup is designed for **local development and testing**, requiring no cloud account.

### Architecture

```
┌────────────────────────────────────────────────────────┐
│  Namespace: omnigraph-example                          │
│                                                        │
│  ┌──────────────────┐      ┌──────────────────┐        │
│  │   omnigraph      │HTTP/│      rustfs       │        │
│  │   :8080 (http)   │─────▶│   :9000 (S3)     │        │
│  │   (graph server) │S3 API│   (S3 storage)   │        │
│  │   ┌────────────┐ │      └────────┬─────────┘        │
│  │   │git-poller  │ │               │                  │
│  │   │(sidecar)   │ │         ┌─────▼───────┐          │
│  │   └────────────┘ │         │  PVC:        │          │
│  │                  │         │  rustfs-data │          │
│  │   ┌────────────┐ │         │  (10Gi)      │          │
│  │   │git-sync   │ │         └──────────────┘          │
│  │   │(init)     │ │                                    │
│  │   └────────────┘ │                                    │
│  └──────────────────┘                                    │
└────────────────────────────────────────────────────────┘
```

### Bootstrapping

The deployment is fully automated:

1. **S3 Bucket Job** — Creates the `omnigraph-local` bucket on RustFS
2. **git-sync initContainer** — Clones the config repo (`config_git_repo`) at startup
3. **import-schema initContainer** — Runs `omnigraph cluster import` to create initial state
4. **apply-graph initContainer** — Runs `omnigraph cluster apply` to create the graph
5. **git-poller sidecar** — Polls git every 5min, restarts Omnigraph on config changes

### Config Repo Structure

The git repo referenced by `config_git_repo` should contain:

```
cluster.yaml     # Omnigraph cluster configuration
schema/
  person.pg      # .pg schema file
graph/
  graph.yaml     # Graph definition (nodes/edges)
```

### cluster.yaml Example

```yaml
version: 1
metadata:
  name: example

state:
  backend: cluster
  lock: true

graphs:
  example:
    schema: schema/person.pg
```

### Schema Format (`.pg`)

```pg
node Person {
  name: String
}
```

⚠️ Note: The `id` field is automatically added by the graph engine — do not include it in the schema.

## Usage

```hcl
module "omnigraph" {
  source = "../examples/omnigraph"

  name        = "my-omnigraph"
  namespace   = "my-omnigraph"
  bearer_token = "my-secret-token"
  # Add secrets.auto.tfvars for git_auth_token
}
```

## Management

- **Health check:** `GET /healthz` (no auth required)
- **Bearer token auth** on all other endpoints
- **Restart Omnigraph:** Delete the pod (the Deployment controller will recreate it):
  ```bash
  kubectl delete pod -n <namespace> -l app=omnigraph
  ```

## Related

- [Omnigraph Deployment Guide](https://www.omnigraph.dev/docs/user/deployment)
- [Testing Against S3 Locally](https://www.omnigraph.dev/docs/user/deployment#testing-against-s3-locally)
- [RustFS](https://github.com/ModernRelay/rustfs)
