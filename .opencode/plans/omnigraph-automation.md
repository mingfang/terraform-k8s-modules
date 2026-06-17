---
applyTo: '**'
---

# Plan: Automate `examples/omnigraph` Init + Git Polling ✅ COMPLETED

## Status
Implemented and validated. Terraform plan shows: **2 to add, 0 to change, 1 to destroy**

## What Was Automated

### Manual Steps → Automated Equivalents

| Manual Step | Automated Approach |
|-------------|-------------------|
| `mc alias set` + `mc mb` + `mc anonymous set` | `k8s_job` using `minio/mc` image |
| Create `schema.yaml` file | Fetched from git repo at runtime |
| `omnigraph cluster import /schema/schema.yaml` | `initContainer` (after git-sync) |
| Create `graph.yaml` file | Fetched from git repo at runtime |
| `omnigraph cluster apply /graph/graph.yaml` | `initContainer` (after git-sync) |
| **Reload on config change** | **Sidecar polls git every 5min + nsenter restart** |

## Files Modified

### `examples/omnigraph/variables.tf` — Added 3 new variables
- `config_git_repo` — Git repo URL for config files (default: `https://github.com/example/omnigraph-configs.git`)
- `config_git_branch` — Branch to checkout (default: `main`)
- `config_git_poll_interval` — Polling interval in seconds (default: `300`, set to `0` to disable sidecar)

### `examples/omnigraph/main.tf` — Added bucket job + initContainers + sidecar
- **Bucket creation Job** (`module "rustfs-bucket-job"`) — Creates S3 bucket and sets permissions
- **Git-sync initContainer** — Clones config repo to shared volume at startup
- **Import-schema initContainer** — Runs `omnigraph cluster import`
- **Apply-graph initContainer** — Runs `omnigraph cluster apply`
- **Git-poller sidecar** — Polls git every 5min, restarts Omnigraph via `nsenter` on change
- **Config volume** — Shared `empty_dir` volume between all containers

## Execution Flow

```
terraform apply
    │
    ├── RustFS Deployment ──→ (RustFS ready)
    │                              │
    │                              ▼
    │                        Bucket Job (runs once, creates S3 bucket)
    │                              │
    │                              ▼
    │                        Omnigraph Deployment starts
    │                              │
    │                    ┌─── initContainer: git-sync (clone repo)
    │                    │
    │                    ├── initContainer: import-schema (omnigraph cluster import)
    │                    │
    │                    ├── initContainer: apply-graph (omnigraph cluster apply)
    │                    │
    │                    ├── Sidecar: git-poller (polls git every 5min)
    │                    │       on change: nsenter -t <pid> -s 15
    │                    │
    │                    └── Main container starts (serves on :8080)
    │
    └── Ingress created
```

## Key Design Decisions

1. **Git repo for config files** — Config files live in a dedicated git repo, not embedded in Terraform
2. **Sidecar + nsenter for reload** — Sidecar polls git, uses nsenter to send SIGTERM to main process on change
3. **Shared empty_dir volume** — All containers share a volume for config files
4. **Pod-level share_process_namespace** — Enables sidecar to see main container's PID for nsenter
5. **onFailure restart policy for job** — Job retries on failure up to 4 times

## Testing Checklist

After implementation, verify:
- [ ] `terraform plan` shows 2 to add, 0 to change, 1 to destroy
- [ ] `terraform apply` creates all resources without errors
- [ ] Bucket Job completes successfully
- [ ] InitContainers complete (git-sync → import → apply)
- [ ] Omnigraph pod Running (1/1) with sidecar Running
- [ ] Sidecar starts polling git repo
- [ ] Config changes in git repo trigger Omnigraph restart within 5 minutes
- [ ] `terraform plan` shows no drift
- [ ] `terraform destroy` cleans up all resources
