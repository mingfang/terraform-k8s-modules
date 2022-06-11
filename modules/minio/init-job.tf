locals {
  host = "${var.name}.${var.namespace}.svc.cluster.local"
}

module "init-job" {
  source    = "../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace
  image     = "minio/mc"

  command = [
    "/bin/bash",
    "-c",
    <<-EOF
    if [ ! -z "$$MINIO_ROOT_USER" ]; then

      until /usr/bin/mc alias set minio http://${local.host}:${var.ports[0].port} $$MINIO_ROOT_USER $$MINIO_ROOT_PASSWORD; do
        sleep 10
      done

      for bucket in ${length(var.create_buckets) > 0 ? join(" ", var.create_buckets) : ""}; do
        /usr/bin/mc mb minio/$bucket || true;
      done

    fi
    EOF
  ]

  env = concat([
    {
      name  = "MINIO_ROOT_USER"
      value = var.minio_access_key
    },
    {
      name  = "MINIO_ROOT_PASSWORD"
      value = var.minio_secret_key
    },
  ], var.env, local.computed_env)

}
