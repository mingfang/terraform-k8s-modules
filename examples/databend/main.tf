resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "meta-service" {
  source    = "../../modules/databend/meta-service"
  name      = "meta-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "query-service" {
  source    = "../../modules/databend/query-service"
  name      = "query-service"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  META_ENDPOINTS = "${module.meta-service.name}:9191"

  env_map = {
    STORAGE_TYPE="s3"
    STORAGE_S3_BUCKET= "databend"
    STORAGE_S3_REGION= "us-east-1"
    STORAGE_S3_ENDPOINT_URL= "http://localstack.localstack-example:4566"
    STORAGE_S3_ACCESS_KEY_ID= "test"
    STORAGE_S3_SECRET_ACCESS_KEY= "test"
    STORAGE_ALLOW_INSECURE= "true"
  }
}

/*
shell into mysql container of the query-service
connect using mysql client
mysql -h127.0.0.1 -uroot -P3307

create user and grand all
CREATE USER databend IDENTIFIED BY 'databend';
GRANT ALL ON *.* TO databend;

confirm
SHOW USERS;
SHOW GRANTS;

query using http
echo '{"sql": "SELECT avg(number) FROM numbers(100000000)"}' | http --auth databend:databend query-service.databend-example:8000/v1/query

*/