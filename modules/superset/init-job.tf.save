module "init-job" {
  source    = "../kubernetes/job"
  name      = "init-job"
  namespace = var.namespace

  image = var.image
  command = [
    "bash",
    "-c",
    <<-EOF
      superset db upgrade
      superset init

      if [[ -v ADMIN_PASSWORD ]] && [[ -v ADMIN_PASSWORD ]]; then
        superset fab create-admin \
          --username $ADMIN_USERNAME \
          --firstname Superset \
          --lastname Admin \
          --email admin@superset.com \
          --password $ADMIN_PASSWORD
      fi

      if [[ -v SUPERSET_LOAD_EXAMPLES ]]; then
        superset load_examples
      fi
    EOF
  ]

  env = var.env

  volumes = var.config_configmap != null ? [
    {
      name = "config"
      config_map = {
        name = var.config_configmap.metadata[0].name
      }
    }
  ] : []

  volume_mounts = var.config_configmap != null ? [
    for k, v in var.config_configmap.data :
    {
      name = "config"

      mount_path = "/app/pythonpath/${k}"
      sub_path   = k
    }
  ] : []
}
