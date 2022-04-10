module "rbac" {
  source    = "../../../modules/kubernetes/rbac"
  name      = var.name
  namespace = var.namespace

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["events", "endpoints"]
      verbs      = ["create", "patch"]
    },
    {
      api_groups = [""]
      resources  = ["pods/eviction"]
      verbs      = ["create"]
    },
    {
      api_groups = [""]
      resources  = ["pods/status"]
      verbs      = ["update"]
    },
    {
      api_groups    = [""]
      resources     = ["endpoints"]
      resourceNames = ["cluster-autoscaler"]
      verbs         = ["get", "update"]
    },
    {
      api_groups = [""]
      resources  = ["nodes"]
      verbs      = ["watch", "list", "get", "update"]
    },
    {
      api_groups = [""]
      resources = [
        "namespaces", "pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"
      ]
      verbs = ["watch", "list", "get"]
    },
    {
      api_groups = ["batch"]
      resources  = ["jobs", "cronjobs"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = ["batch", "extensions"]
      resources  = ["jobs"]
      verbs      = ["get", "list", "watch", "patch"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["replicasets", "daemonsets"]
      verbs      = ["watch", "list", "get"]
    },
    {
      api_groups = ["policy"]
      resources  = ["poddisruptionbudgets"]
      verbs      = ["watch", "list"]
    },
    {
      api_groups = ["apps"]
      resources  = ["statefulsets", "replicasets", "daemonsets"]
      verbs      = ["watch", "list", "get"]
    },
    {
      api_groups = ["storage.k8s.io"]
      resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
      verbs      = ["watch", "list", "get"]
    },
    {
      api_groups = [""]
      resources  = ["configmaps"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["coordination.k8s.io"]
      resources  = ["leases"]
      verbs      = ["create"]
    },
    {
      api_groups    = ["coordination.k8s.io"]
      resourceNames = ["cluster-autoscaler"]
      resources     = ["leases"]
      verbs         = ["get", "update"]
    }
  ]

  role_rules = [
    {
      api_groups = [""]
      resources : ["configmaps"]
      verbs : ["create", "list", "watch"]
    },
    {
      api_groups = [""]
      resources : ["configmaps"]
      resourceNames : ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
      verbs : ["delete", "get", "update", "watch"]
    },
    {
      api_groups = [""]
      resources : ["configmaps"]
      resourceNames : ["cluster-autoscaler"]
      verbs : ["get", "update"]
    }
  ]

}