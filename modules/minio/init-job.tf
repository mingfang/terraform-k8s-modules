locals {
  host = "${var.name}.${var.namespace}.svc.cluster.local"
}

module "init-job" {
  source    = "../kubernetes/job"
  name      = "init"
  namespace = var.namespace
  image     = "minio/mc"

  command = [
    "/bin/bash",
    "-c",
    <<-EOF
    until curl -s http://${local.host}:${var.ports[0].port}/minio/health/live; do
      sleep 10
    done
    /usr/bin/mc alias set minio http://${local.host}:${var.ports[0].port} ${var.minio_access_key} ${var.minio_secret_key};
    for bucket in ${length(var.create_buckets) > 0 ? join(" ", var.create_buckets) : ""}; do
      /usr/bin/mc mb minio/$bucket;
    done
    EOF
  ]
}
