output "kafka_bootstrap_servers" {
  value = "${module.kafka.name}:9092"
}

output "kafka_connect_source" {
  value = "${module.kafka-connect-source.name}:8083"
}

output "kafka_connect_sink" {
  value = "${module.kafka-connect-sink.name}:8083"
}

output "kafka_topic_ui_name" {
  value = module.kafka-topic-ui.name
}

output "kafka_connect_ui_name" {
  value = module.kafka-connect-ui.name
}

//output "kafka-topic-ui-port" {
//  value = module.kafka-topic-ui.port
//}

