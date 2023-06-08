resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  env =  { for tuple in regexall("(\\w+)=(.+)", file("${path.module}/.env")) : tuple[0] => tuple[1] }
  kube_env =  [ for k,v in local.env : { name = k, value = v} ]
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_USER     = local.env["PGUSER"]
  POSTGRES_PASSWORD = local.env["PGPASSWORD"]
  POSTGRES_DB       = local.env["PGPASSWORD"]

  image = "openmaptiles/postgis:${local.env["TOOLS_VERSION"]}"
}

module "import-data-job" {
  source    = "../../modules/openmaptiles/import-data-job"
  name      = "import-data-job"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env = local.kube_env
}

module "postserve" {
  source    = "../../modules/openmaptiles/postserve"
  name      = "postserve"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env = local.kube_env
  TILESET_FILE = local.env["TILESET_FILE"]
}