
# Example `agentenv`

Deploys the [AgentENV](https://github.com/kvcache-ai/AgentENV) stack on
Kubernetes, following the upstream
[Multi-Node deployment](https://kvcache-ai.github.io/AgentENV/deployment/kubernetes.html)
architecture (not the docker-compose single-host layout).

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Architecture

```
            ingress (:8080)
               |
        agentenv-gateway (Deployment) ──► agentenv-scheduler (Deployment, gRPC :9090)
                                             │ discovers nodes via EndpointSlices for
                                             │ the headless `agentenv-nodes` Service
                                             ▼
        agentenv-node (DaemonSet, privileged) ── one pod per KVM node (:8000, :9103)
```

| upstream kind      | module / resource       | image                      | ports         |
|--------------------|-------------------------|----------------------------|---------------|
| DaemonSet          | `module.agentenv_node`  | `agentenv-runtime:latest`  | 8000, 9103    |
| Headless Service    | `k8s_core_v1_service.agentenv_nodes` | —              | 8000          |
| Deployment         | `module.agentenv_scheduler` | `agentenv-scheduler:latest` | grpc 9090 |
| Deployment         | `module.agentenv_gateway`  | `agentenv-gateway:latest`   | http 8080  |

### Why a DaemonSet for the runtime

Each runtime pod needs host-local access to `/dev/kvm` (and ublk devices), host
iptables/network namespaces for sandbox networking, and per-host cached state at
`/var/lib/aenv`. A DaemonSet places one pod per qualifying node and mounts those
host paths directly. `AENV_NODE_ID` is derived from the pod name
(`fieldRef: metadata.name`), so each node self-registers with the scheduler.

### Service discovery

The scheduler does **not** use a static node list. Its config enables
`discovery.mode = "kubernetes"` and watches EndpointSlices for the headless
`agentenv-nodes` Service (`clusterIP: None`, `publishNotReadyAddresses: true`).
The scheduler's ServiceAccount is granted a namespaced Role to `get/list/watch`
`endpointslices` and `pods`.

## Input Variables
* `name` (default `"agentenv"`)
* `namespace` (default `"agentenv-example"`)
* `is_create_namespace` (default `true`)
* `runtime_image` (default `"ghcr.io/kvcache-ai/aenv-server:latest"`)
* `scheduler_image` (default `"agentenv-scheduler:latest"`)
* `gateway_image` (default `"agentenv-gateway:latest"`)
* `sandbox_proxy_domains` (default `""`)
* `runtime_node_selector` (default `{ node-type = "epyc" }`)

## Managed Resources
* `k8s_core_v1_namespace.this` (via `../namespace`) from `k8s`
* `k8s_core_v1_service.agentenv_nodes` (headless) from `k8s`
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `agentenv_node` from [../../modules/generic-daemonset](../../modules/generic-daemonset)
* `agentenv_scheduler` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `agentenv_gateway` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `runtime_config` / `scheduler_config` / `gateway_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

## Prerequisites

### 1. Images

The **runtime** image is prebuilt and published to GHCR:
`ghcr.io/kvcache-ai/aenv-server:latest` — no build needed.

The **scheduler** and **gateway** images are NOT published. Build them from the
AgentENV repo and push to your registry:

```bash
# in the AgentENV repo
make k8s-build   # builds agentenv-runtime/gateway/scheduler:latest

docker tag agentenv-scheduler:latest your-registry/agentenv-scheduler:latest
docker tag agentenv-gateway:latest   your-registry/agentenv-gateway:latest
docker push your-registry/agentenv-scheduler:latest
docker push your-registry/agentenv-gateway:latest
```

```hcl
# .auto.tfvars
scheduler_image = "your-registry/agentenv-scheduler:latest"
gateway_image   = "your-registry/agentenv-gateway:latest"
```

### 2. KVM-capable nodes (labeled `node-type=epyc`)

The runtime DaemonSet is pinned to nodes labeled `node-type=epyc`. These nodes
must run Linux 6.8+ and expose `/dev/kvm`. Label them:

```bash
kubectl label node <node> node-type=epyc
```

Override `runtime_node_selector` in `.auto.tfvars` if you use a different label.
The runtime pods are privileged and mount host `/dev` and `/var/lib/aenv`.

### 3. Config files

* `config/default.toml` — runtime config, copied verbatim from the AgentENV repo
  (mounted at `/workspace/config/default.toml`).
* `scheduler.json` and `gateway.json` — generated via `jsonencode` in `main.tf`
  (the scheduler config references `var.namespace` for Kubernetes discovery, so
  it is templated rather than checked in). Edit the locals in `main.tf` if you
  need to change the strategy, timeouts, or discovery settings.

## Deploy

```bash
terraform init
terraform apply
```

The gateway is exposed via an nginx ingress on host `agentenv-example`.

## Notes

* The scheduler runs as a **single replica**: sandbox bindings are held
  in-memory and are lost on restart (per upstream design).
* The runtime container has a `startupProbe` with `failureThreshold: 48`
  (`period: 5s` ≈ 4 min) because initial asset setup is slow. `preStop` drains
  sandboxes before termination (`terminationGracePeriodSeconds: 3600`), and
  `postStart` disables cgroup v2 `memory.oom.group` so a firecracker child OOM
  does not kill the server.
* `generic-daemonset` now supports `ports_map`, `image_pull_policy`,
  `liveness_probe`/`readiness_probe`/`startup_probe`, `_lifecycle`,
  `termination_grace_period_seconds`, `config_files`, and `init_containers`
  variables (mirroring `generic-deployment-service`), so the runtime container
  is configured entirely through module variables — no `overrides` needed.
