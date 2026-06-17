---
applyTo: '**'
---

# Plan: Create `examples/omnigraph` from `template-example`

## Goal
Create a new Terraform example for **Omnigraph** (lakehouse-native graph engine by Modern Relay) using `examples/template-example` as a scaffold.

## What is Omnigraph?
- **Image**: `modernrelay/omnigraph-server` (pushed to AWS ECR, placeholder for now)
- **Port**: `8080` (default, configurable via `OMNIGRAPH_BIND`)
- **Health endpoint**: `GET /healthz` (no auth required, suitable for LB health checks)
- **Storage backend**: S3-compatible object store (env vars: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`)
- **Auth**: `OMNIGRAPH_SERVER_BEARER_TOKEN` env var (bearer token, implicit actor `default`)
- **Mode**: S3-backed graph mode via `OMNIGRAPH_TARGET_URI` (preferred cloud pattern, no volume needed)
- **CLI**: `omnigraph` CLI included in image for day-2 cluster apply operations

## Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Image | Placeholder (`var.image` with `ghcr.io/modernrelay/omnigraph-server:latest`) | No stable public image yet |
| Mode | S3-backed graph (`OMNIGRAPH_TARGET_URI`) | Simplest, stateless, no volume needed |
| Auth | Configurable `var.bearer_token` variable (not sensitive per convention) | `mingfang/k8s` provider cannot render sensitive vars during plan |
| S3 creds | Configurable variables | Required for S3 access |
| Ingress | Yes, nginx class, SSL redirect, server-alias on `${namespace}.*` | Matches `template-example` pattern |
| Port | 8080 | Omnigraph default (`EXPOSE 8080` in Dockerfile) |
| Resources | 250m CPU / 256Mi mem request, 1 CPU / 512Mi mem limit | Reasonable defaults for graph server |

## Files to Create

### 1. `examples/omnigraph/copier.yml`

Copier template parameters for future generation. Omits `configmap_mount_path` and `args` from template since omnigraph runs via env vars, not CLI args.

```yaml
name:
  type: str
namespace:
  type: str
  default: "{{name}}-example"
image:
  type: str
  default: "ghcr.io/modernrelay/omnigraph-server:latest"
bearer_token:
  type: str
  default: "change-me"
graph_uri:
  type: str
  default: "s3://my-bucket/graphs/example"
aws_access_key_id:
  type: str
  default: ""
aws_secret_access_key:
  type: str
  default: ""
aws_region:
  type: str
  default: "us-east-1"
aws_endpoint_url:
  type: str
  default: ""
aws_s3_force_path_style:
  type: str
  default: "false"
bind_address:
  type: str
  default: "0.0.0.0:8080"
_templates_suffix: ""
_exclude: ["copier.yaml", "copier.yml", "~*", "*.py[co]", "__pycache__", ".git", ".DS_Store", ".svn", "node_modules", ".idea", "*.iml", "README.md"]
```

### 2. `examples/omnigraph/variables.tf`

```hcl
variable "name" {
  description = "Name of the omnigraph deployment"
  default     = "omnigraph"
}

variable "namespace" {
  description = "Kubernetes namespace"
  default     = "omnigraph-example"
}

variable "is_create_namespace" {
  description = "Whether to create the namespace"
  default     = true
}

variable "image" {
  description = "Container image for omnigraph-server"
  default     = "ghcr.io/modernrelay/omnigraph-server:latest"
}

variable "bearer_token" {
  description = "Bearer token for server authentication (assigns implicit actor 'default')"
  default     = "change-me"
}

variable "graph_uri" {
  description = "S3 graph URI, e.g. s3://bucket/graphs/example (maps to OMNIGRAPH_TARGET_URI)"
  default     = "s3://my-bucket/graphs/example"
}

variable "aws_access_key_id" {
  description = "AWS access key ID for S3 graph storage"
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret access key for S3 graph storage"
  default     = ""
}

variable "aws_region" {
  description = "AWS region for S3 graph storage"
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "Optional S3-compatible endpoint URL (e.g. for RustFS or MinIO)"
  default     = ""
}

variable "aws_s3_force_path_style" {
  description = "Whether to force path-style S3 URLs (for S3-compatible stores like RustFS/MinIO)"
  default     = "false"
}

variable "bind_address" {
  description = "Server listen address (maps to OMNIGRAPH_BIND)"
  default     = "0.0.0.0:8080"
}
```

### 3. `examples/omnigraph/versions.tf`

```hcl
terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
    }
  }
}
```

### 4. `examples/omnigraph/main.tf`

```hcl
module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

locals {
  env_map = merge(
    {
      OMNIGRAPH_TARGET_URI  = var.graph_uri
      OMNIGRAPH_BIND        = var.bind_address
      OMNIGRAPH_SERVER_BEARER_TOKEN = var.bearer_token
      AWS_REGION            = var.aws_region
    },
    var.aws_access_key_id != "" ? { AWS_ACCESS_KEY_ID = var.aws_access_key_id } : {},
    var.aws_secret_access_key != "" ? { AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key } : {},
    var.aws_endpoint_url != "" ? { AWS_ENDPOINT_URL = var.aws_endpoint_url } : {},
    var.aws_s3_force_path_style != "" ? { AWS_S3_FORCE_PATH_STYLE = var.aws_s3_force_path_style } : {},
  )
}

module "omnigraph" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = var.image

  ports = [{ name = "http", port = 8080 }]
  env_map = local.env_map

  liveness_probe = {
    initial_delay_seconds = 15
    period_seconds        = 15
    failure_threshold     = 3

    http_get = {
      path = "/healthz"
      port = 8080
    }
  }

  resources = {
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.omnigraph.name
              port {
                number = module.omnigraph.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
```

### 5. `examples/omnigraph/outputs.tf`

```hcl
output "name" {
  description = "Name of the omnigraph deployment"
  value       = module.omnigraph.name
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = module.namespace.name
}

output "port" {
  description = "Service port number"
  value       = module.omnigraph.ports[0].port
}

output "service_name" {
  description = "Kubernetes service name"
  value       = module.omnigraph.name
}
```

### 6. `examples/omnigraph/README.md`

```markdown
# Module `omnigraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"omnigraph"`) — Name of the omnigraph deployment
* `namespace` (default `"omnigraph-example"`) — Kubernetes namespace
* `image` (default `"ghcr.io/modernrelay/omnigraph-server:latest"`) — Container image
* `bearer_token` (default `"change-me"`) — Bearer token for server authentication
* `graph_uri` (default `"s3://my-bucket/graphs/example"`) — S3 graph URI
* `aws_access_key_id` (default `""`) — AWS access key ID
* `aws_secret_access_key` (default `""`) — AWS secret access key
* `aws_region` (default `"us-east-1"`) — AWS region
* `aws_endpoint_url` (default `""`) — S3-compatible endpoint URL (e.g. RustFS, MinIO)
* `aws_s3_force_path_style` (default `"false"`) — Force path-style S3 URLs
* `bind_address` (default `"0.0.0.0:8080"`) — Server listen address
* `is_create_namespace` (default `true`) — Whether to create the namespace

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `omnigraph` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

## Documentation
* [Omnigraph Deployment Docs](https://www.omnigraph.dev/docs/user/deployment#container-entrypoint-env-vars)

## Usage Example

```hcl
module "omnigraph" {
  source = "../examples/omnigraph"

  name             = "my-omnigraph"
  namespace        = "my-omnigraph"
  bearer_token     = "my-secret-token"
  graph_uri        = "s3://my-bucket/graphs/my-graph"
  aws_access_key_id = "AKIA..."
  aws_secret_access_key = "..."
  aws_region       = "us-east-1"
}
```

For S3-compatible stores (RustFS, MinIO), set:
```hcl
  aws_endpoint_url    = "http://minio:9000"
  aws_s3_force_path_style = "true"
```
```

## Mapping: Omnigraph Env Vars → Terraform Variables

| Omnigraph Env Var | Terraform Variable | Description |
|-------------------|--------------------|-------------|
| `OMNIGRAPH_TARGET_URI` | `var.graph_uri` | S3 graph URI |
| `OMNIGRAPH_BIND` | `var.bind_address` | Listen address |
| `OMNIGRAPH_SERVER_BEARER_TOKEN` | `var.bearer_token` | Bearer token auth |
| `AWS_ACCESS_KEY_ID` | `var.aws_access_key_id` | S3 access key |
| `AWS_SECRET_ACCESS_KEY` | `var.aws_secret_access_key` | S3 secret key |
| `AWS_REGION` | `var.aws_region` | S3 region |
| `AWS_ENDPOINT_URL` | `var.aws_endpoint_url` | S3-compatible endpoint |
| `AWS_S3_FORCE_PATH_STYLE` | `var.aws_s3_force_path_style` | Path-style URLs for S3-compatible |

## Notes
- No PVC needed: S3-backed mode is volume-free (the preferred cloud pattern per docs)
- Health check: `GET /healthz` (always available, not gated by auth)
- The `mingfang/k8s` provider cannot render sensitive variables during plan, so `bearer_token` is **not** marked `sensitive = true` (value should be stored in `.auto.tfvars` instead)
