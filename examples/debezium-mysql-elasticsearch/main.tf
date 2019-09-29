/**
 * Use Debezium and Kafka Connect to sync from MySql to Elasticsearch.
 *
 * Based on https://github.com/debezium/debezium-examples/tree/master/unwrap-smt
 *
 * Ingress:\
 * You must set the ingress_host variable to the IP address of any node.\
 * The default will most likely not match yours.
 *
 * Storage:\
 * The [nfs-server-empty-dir](https://github.com/mingfang/terraform-provider-k8s/tree/master/modules/nfs-server-empty-dir) module
 * is used for temporary storage, making the example easy to run and clean up.
 *
 * Instructions:
 * 1. Create alias to run Terraform with this Kubernetes plugin.
 *    ```
 *    alias tf='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform terraform'
 *    ```
 * 2. Copy the kubeconfig file for your cluster to the current directory.
 * 3. Create a Terraform file to include this example, like this
 *    ```
 *    module "debezium-mysql-es" {
 *      source = "../../examples/debezium-mysql-elasticsearch"
 *      ingress_host = "<IP of any node, e.g. 192.168.2.146>"
 *    }
 *
 *    output "urls" {
 *      value = module.debezium-mysql-es.urls
 *    }
 *    ```
 * 4. Run init to download the modules.
 *    ```
 *    tf init
 *    ```
 * 5. Run apply
 *    ```
 *    tf apply
 *    ```
 * 6. The output includes a list of URLs that can be used to access Kafka and Elasticsearch.
 *    ```
 *    Outputs:
 *
 *    urls = [
 *        http://kafka-connect-ui.192.168.2.146.nip.io:30000,
 *        http://kafka-topic-ui.192.168.2.146.nip.io:30000,
 *        http://elasticsearch.192.168.2.146.nip.io:30000
 *    ]
 *    ```
 * 7. After a couple of minutes, you should see customer data sync from MySql to Elasticsearch.
 *    ```
 *    curl <Elasticsearch URL>/customers/_search?pretty
 *    ```
 * 8. Run destory to clean up.
 *    ```
 *    tf destroy
 *    ```
*/


module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "zookeeper_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "kafka_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-kafka"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "elasticsearch_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "${var.name}-elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "mysql" {
  source    = "./mysql"
  name      = "${var.name}-mysql"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "debezium/example-mysql"

  mysql_user          = "mysqluser"
  mysql_password      = "mysqlpw"
  mysql_database      = ""
  mysql_root_password = "debezium"
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "${var.name}-elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = module.elasticsearch_storage.replicas

  storage_class_name = module.elasticsearch_storage.storage_class_name
  storage            = module.elasticsearch_storage.storage
}

module "debezium" {
  source    = "../../solutions/debezium"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  zookeeper_storage_class = module.zookeeper_storage.storage_class_name
  zookeeper_storage       = module.zookeeper_storage.storage
  zookeeper_count         = module.zookeeper_storage.replicas
  kafka_storage_class     = module.kafka_storage.storage_class_name
  kafka_storage           = module.kafka_storage.storage
  kafka_count             = module.kafka_storage.replicas
}

data "template_file" "source" {
  template = "${file("${path.module}/source.json")}"

  vars = {
    name                                     = "${var.name}-source-connector"
    database_hostname                        = module.mysql.name
    database_port                            = module.mysql.port
    database_user                            = "root"
    database_password                        = "debezium"
    database_server_id                       = "184054"
    database_server_name                     = "dbserver1"
    database_whitelist                       = "inventory"
    database_history_kafka_bootstrap_servers = module.debezium.kafka_bootstrap_servers
    database_history_kafka_topic             = "${var.name}.schema-changes"
  }
}

module "job_source" {
  source    = "../../solutions/debezium/job"
  name      = "${var.name}-source-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  kafka_connect    = module.debezium.kafka_connect_source
  connector_name   = module.mysql.name
  connector_config = data.template_file.source.rendered
}

data "template_file" "sink" {
  template = "${file("${path.module}/sink.json")}"

  vars = {
    name           = "elastic-sink"
    topics         = var.topics
    topics_regex   = ""
    connection_url = "http://${module.elasticsearch.name}:9200"
  }
}

module "job_sink" {
  source    = "../../solutions/debezium/job"
  name      = "${var.name}-sink-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  kafka_connect    = module.debezium.kafka_connect_sink
  connector_name   = module.elasticsearch.name
  connector_config = data.template_file.sink.rendered
}
