module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace

  from-map = {
    "whisk_api_host_name"        = var.whisk_api_host_name
    "whisk_api_host_nameAndPort" = "${var.whisk_api_host_name}:${var.whisk_api_host_port}"
    "whisk_api_host_port"        = var.whisk_api_host_port
    "whisk_api_host_proto"       = var.whisk_api_host_proto
    "whisk_api_host_url"         = "${var.whisk_api_host_proto}://${var.whisk_api_host_name}:${var.whisk_api_host_port}"
    "whisk_cli_version_tag"      = "1.0.0"
    "whisk_info_buildNo"         = "20200617a"
    "whisk_info_date"            = "2020-06-17-15:21:13Z"
    "whisk_system_namespace"     = "/whisk.system"
  }
}