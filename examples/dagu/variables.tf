variable "name" {
  default = "dagu"
}

variable "namespace" {
  default = "dagu-example"
}

variable "is_create_namespace" {
  default = true
}

variable "image" {
  # default = "registry.rebelsoft.com/dagu:683ee5b7-29671022"
  default = "ghcr.io/dagucloud/dagu:latest"
}

variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token for the git-sync DAG"
}

variable "git_sync_repo" {
  type        = string
  default     = "github.com/dagucloud/dagu.git"
  description = "Git repository URL to sync DAG definitions from"
}
