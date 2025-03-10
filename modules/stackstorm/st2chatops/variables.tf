variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "stackstorm/st2chatops:3.6.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "ST2_AUTH_URL" {}
variable "ST2_API_URL" {}
variable "ST2_STREAM_URL" {}

variable "HUBOT_ADAPTER" {}
variable "HUBOT_LOG_LEVEL" {
  default = "info"
}

# See all env here https://github.com/StackStorm/st2chatops/blob/master/st2chatops.env
# For auth add env ST2_API_KEY OR ST2_AUTH_USERNAME & ST2_AUTH_PASSWORD
# For slack add env HUBOT_SLACK_TOKEN