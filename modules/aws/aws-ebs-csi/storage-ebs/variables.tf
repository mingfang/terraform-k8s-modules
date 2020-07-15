variable "name" {}

variable "namespace" {}

//variable "storage" {}

variable "annotations" {
  default = {}
}

variable "aws_ebs_volumes" {
  type = list(any)
  description = "list of aws_ebs_volume"
}
/*
variable "volume_handles" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}
*/

variable "fstype" {
  default = "xfs"
}
