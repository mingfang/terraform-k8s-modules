terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
    }
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "1.9.5"
    }
  }
}
