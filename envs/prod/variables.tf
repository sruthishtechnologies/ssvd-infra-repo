variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-2"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name."
  type        = string
  default     = "ssvd"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.20.0.0/16"
}

variable "az_count" {
  description = "Availability zone count."
  type        = number
  default     = 2
}

variable "cluster_version" {
  description = "EKS Kubernetes version. Null lets AWS choose the current supported default."
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "Managed node group instance types."
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_size" {
  description = "Desired node count."
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum node count."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum node count."
  type        = number
  default     = 2
}

variable "enable_argocd" {
  description = "Install Argo CD and the environment root app."
  type        = bool
  default     = true
}

variable "ops_repo_url" {
  description = "GitOps repository URL."
  type        = string
  default     = "https://github.com/sruthishtechnologies/ssvd-ops-repo.git"
}

variable "ops_repo_revision" {
  description = "GitOps repository revision."
  type        = string
  default     = "main"
}

variable "github_org" {
  description = "GitHub organization or user for OIDC trust."
  type        = string
  default     = "sruthishtechnologies"
}

variable "github_repositories" {
  description = "Repositories allowed to assume the GitHub Actions role."
  type        = set(string)
  default     = ["ssvd-infra-repo", "ssvd-bhoomi-report", "ssvd-ops-repo"]
}

variable "create_github_oidc_provider" {
  description = "Create GitHub OIDC provider. Set false if it already exists in the AWS account."
  type        = bool
  default     = true
}

variable "create_github_actions_role" {
  description = "Create an IAM role for GitHub Actions."
  type        = bool
  default     = false
}
