terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
    }
    bytebase = {
      source  = "bytebase/bytebase"
      version = ">= 1.0"
    }
  }
}
