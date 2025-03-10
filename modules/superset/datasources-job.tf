module "datasources-job" {
  source    = "../kubernetes/job"
  name      = "datasources-job"
  namespace = var.namespace
  annotations = {
    "datasources-checksum" : var.datasources_configmap != null ? md5(join("", keys(var.datasources_configmap.data), values(var.datasources_configmap.data))) : ""
  }

  image = var.image
  command = [
    "bash",
    "-c",
    <<-EOF
      exec 3< <(find "/tmp/datasources" -maxdepth 1 -mindepth 1 -type f -print0 | sort -z)
      while IFS= read -u 3 -r -d '' DATASOURCE_PATH; do
        superset import-datasources -p $DATASOURCE_PATH
      done
    EOF
  ]

  env = var.env

  volumes = concat(
    var.config_configmap != null ? [
      {
        name = "config"
        config_map = {
          name = var.config_configmap.metadata[0].name
        }
      }
    ] : [],
    var.datasources_configmap != null ? [
      {
        name = "datasources"
        config_map = {
          name = var.datasources_configmap.metadata[0].name
        }
      }
    ] : [],
  )

  volume_mounts = concat(
    var.config_configmap != null ? [
      for k, v in var.config_configmap.data :
      {
        name = "config"

        mount_path = "/app/pythonpath/${k}"
        sub_path   = k
      }
    ] : [],
    var.datasources_configmap != null ? [
      for k, v in var.datasources_configmap.data :
      {
        name = "datasources"

        mount_path = "/tmp/datasources/${k}"
        sub_path   = k
      }
    ] : [],
  )
}
