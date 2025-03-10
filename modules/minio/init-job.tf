locals {
  host = "${var.name}.${var.namespace}.svc.cluster.local"
}

module "init-job" {
  source    = "../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace
  annotations = var.policies_configmap != null ? {
    config_checksum = md5(join("", keys(var.policies_configmap.data), values(var.policies_configmap.data)))
  } : {}

  image = "minio/mc"

  command = [
    "/bin/bash",
    "-c",
    <<-EOF
    if [ ! -z "$$MINIO_ROOT_USER" ]; then

      # wait for server
      until /usr/bin/mc alias set minio http://${local.host}:${var.ports[0].port} $$MINIO_ROOT_USER $$MINIO_ROOT_PASSWORD; do
        sleep 10
      done

      # create buckets
      for bucket in ${length(var.create_buckets) > 0 ? join(" ", var.create_buckets) : ""}; do
        /usr/bin/mc mb minio/$bucket || true;
      done

      # create policies
      for FILE in /policies/*.json; do
        test -f "$FILE" || continue
        echo "adding $FILE"
        FILENAME=$(basename -- "$FILE")
        POLICY="$${FILENAME%.*}"
        mc admin policy add minio $POLICY $FILE
      done
    fi
    EOF
  ]

  env = concat(
    var.minio_access_key != null ? [
      {
        name  = "MINIO_ROOT_USER"
        value = var.minio_access_key
      }
    ] : [],
    var.minio_secret_key != null ? [
      {
        name  = "MINIO_ROOT_PASSWORD"
        value = var.minio_secret_key
      }
    ] : [], 
    var.env, local.computed_env
  )
  
  env_from = var.env_from
  
  volume_mounts = var.policies_configmap != null ? [
    for k, v in var.policies_configmap.data :
    {
      name       = "config"
      mount_path = "/policies/${k}"
      sub_path   = k
    }
  ] : []

  volumes = var.policies_configmap != null ? [
    {
      name = "config"

      config_map = {
        name = var.policies_configmap.metadata[0].name
      }
    }
  ] : []
}
