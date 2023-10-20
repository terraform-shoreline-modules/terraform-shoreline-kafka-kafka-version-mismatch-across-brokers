resource "shoreline_notebook" "kafka_version_mismatch_across_brokers" {
  name       = "kafka_version_mismatch_across_brokers"
  data       = file("${path.module}/data/kafka_version_mismatch_across_brokers.json")
  depends_on = [shoreline_action.invoke_upgrade_kafka]
}

resource "shoreline_file" "upgrade_kafka" {
  name             = "upgrade_kafka"
  input_file       = "${path.module}/data/upgrade_kafka.sh"
  md5              = filemd5("${path.module}/data/upgrade_kafka.sh")
  description      = "Upgrade the broker(s) running the older version of Kafka to the target version."
  destination_path = "/tmp/upgrade_kafka.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_upgrade_kafka" {
  name        = "invoke_upgrade_kafka"
  description = "Upgrade the broker(s) running the older version of Kafka to the target version."
  command     = "`chmod +x /tmp/upgrade_kafka.sh && /tmp/upgrade_kafka.sh`"
  params      = ["TARGET_VERSION","BROKER_HOST"]
  file_deps   = ["upgrade_kafka"]
  enabled     = true
  depends_on  = [shoreline_file.upgrade_kafka]
}

