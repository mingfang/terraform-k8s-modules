terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
    }
    pagerduty = {
      source = "pagerduty/pagerduty"
    }
  }
  required_version = ">= 0.13"
}