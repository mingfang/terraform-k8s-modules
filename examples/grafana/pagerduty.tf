provider "pagerduty" {
  token = "<your pagerduty token>"
}

data "pagerduty_escalation_policy" "default" {
  name = "Default"
}

resource "pagerduty_service" "ingress" {
  name                    = "Ingress"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = data.pagerduty_escalation_policy.default.id
  alert_creation          = "create_alerts_and_incidents"
}

resource "pagerduty_service_integration" "ingress" {
  name    = "alertmanager"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.ingress.id
}
