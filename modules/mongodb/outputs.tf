locals {
  seed_list = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}"
    ]
  )
}

output "seed_list" {
  value = "${local.seed_list}?replicaSet=${var.replica_set}"
}

output "name" {
  value = var.name
}

output "ports" {
  value = var.ports
}

output "service" {
  value = module.statefulset-service.service
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
