module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  role_rules = [
    {
      api_groups : [
        "",
      ]
      resources : [
        "secrets",
      ]
      resource_names : [
        "kubernetes-dashboard-key-holder",
        "kubernetes-dashboard-certs",
        "kubernetes-dashboard-csrf",
      ]
      verbs : [
        "get",
        "update",
        "delete",
      ]
    },
    {
      api_groups : [
        "",
      ]
      resources : [
        "configmaps",
      ]
      resource_names : [
        "kubernetes-dashboard-settings",
      ]
      verbs : [
        "get",
        "update",
      ]
    },
    {
      api_groups : [
        "",
      ]
      resources : [
        "services",
      ]
      resource_names : [
        "heapster",
        "dashboard-metrics-scraper",
      ]
      verbs : [
        "proxy",
      ]
    },
    {
      api_groups : [
        "",
      ]
      resources : [
        "services/proxy",
      ]
      resource_names : [
        "heapster",
        "http:heapster:",
        "https:heapster:",
        "dashboard-metrics-scraper",
        "http:dashboard-metrics-scraper",
      ]
      verbs : [
        "get",
      ]
    }
  ]
}
