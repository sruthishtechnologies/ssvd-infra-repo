variable "namespace" {
  description = "Namespace where Argo CD is installed."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version."
  type        = string
  default     = "7.8.2"
}

variable "ops_repo_url" {
  description = "GitOps repository URL watched by Argo CD."
  type        = string
}

variable "ops_repo_revision" {
  description = "Git revision watched by Argo CD."
  type        = string
  default     = "main"
}

variable "ops_repo_bootstrap_path" {
  description = "Path in the ops repo containing the environment root application."
  type        = string
}

variable "root_app_name" {
  description = "Root Argo CD Application name."
  type        = string
}

variable "server_service_type" {
  description = "Argo CD server service type."
  type        = string
  default     = "ClusterIP"
}
