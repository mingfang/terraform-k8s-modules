variable "name" {
  type    = string
  default = "s3fs"
}

variable "namespace" {
  type = string
}

variable "secret_name" {
  description = "accessKeyID=YOUR_ACCESS_KEY_ID, secretAccessKey=YOUR_SECRET_ACCESS_KEY, endpoint=\"https://s3.<region>.amazonaws.com\""
}
