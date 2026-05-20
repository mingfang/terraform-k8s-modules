variable "name" {
  default = "dagu"
}

variable "namespace" {
  default = "dagu-example"
}

variable "is_create_namespace" {
  default = true
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
