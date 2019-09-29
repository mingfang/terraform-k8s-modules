variable "name" {
  default = "debezium-postgres-es"
}

//comma separated list of tables to sync
variable "topics" {
  default = "musicgroup,musicalbum,musicrecording"
}

module "nfs-server" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name   = "nfs-server"
}

module "zookeeper_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name    = "${var.name}-zookeeper"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${module.nfs-server.mount_options}"
}

module "kafka_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name    = "${var.name}-kafka"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${module.nfs-server.mount_options}"
}

module "elasticsearch_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name    = "${var.name}-elasticsearch"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${module.nfs-server.mount_options}"
}

module "postgres_storage" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name       = "${var.name}-postgres"
  count      = 1
  storage    = "1Gi"
  nfs_server = "${module.nfs-server.cluster_ip}"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }
}

module "postgres" {
  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/postgres"
  name               = "${var.name}"
  image              = "debezium/postgres"
  storage_class_name = "${module.postgres_storage.storage_class_name}"
  storage            = "${module.postgres_storage.storage}"
  replicas           = "${module.postgres_storage.count}"

  postgres_user     = "postgres"
  postgres_password = "postgres"
  postgres_db       = "postgres"
}

module "elasticsearch" {
  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/elasticsearch"
  name               = "${var.name}-elasticsearch"
  storage_class_name = "${module.elasticsearch_storage.storage_class_name}"
  storage            = "${module.elasticsearch_storage.storage}"
  replicas           = "${module.elasticsearch_storage.count}"
}

module "debezium" {
  source                  = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium"
  name                    = "${var.name}"
  zookeeper_storage_class = "${module.zookeeper_storage.storage_class_name}"
  zookeeper_storage       = "${module.zookeeper_storage.storage}"
  zookeeper_count         = "${module.zookeeper_storage.count}"
  kafka_storage_class     = "${module.kafka_storage.storage_class_name}"
  kafka_storage           = "${module.kafka_storage.storage}"
  kafka_count             = "${module.kafka_storage.count}"
}

data "template_file" "source" {
  template = "${file("${path.module}/source.json")}"

  vars {
    name                                     = "${var.name}-source-connector"
    database.hostname                        = "${module.postgres.name}"
    database.port                            = "${module.postgres.port}"
    database.user                            = "postgres"
    database.password                        = "postgres"
    database.dbname                          = "postgres"
    database.server.name                     = "postgres"
    database.whitelist                       = "${var.topics}"
    database.history.kafka.bootstrap.servers = "${module.debezium.kafka_bootstrap_servers}"
    database.history.kafka.topic             = "${var.name}.schema-changes"
  }
}

module "job_source" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium/job"
  name   = "${var.name}-source-init"

  kafka_connect    = "${module.debezium.kafka_connect_source}"
  connector_name   = "${module.postgres.name}"
  connector_config = "${data.template_file.source.rendered}"
}

data "template_file" "sink" {
  template = "${file("${path.module}/sink.json")}"

  vars {
    name           = "elastic-sink"
    topics         = "${var.topics}"
    topics.regex   = ""
    connection.url = "http://${module.elasticsearch.name}:9200"
  }
}

module "job_sink" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium/job"
  name   = "${var.name}-sink-init"

  kafka_connect    = "${module.debezium.kafka_connect_sink}"
  connector_name   = "${module.elasticsearch.name}"
  connector_config = "${data.template_file.sink.rendered}"
}
