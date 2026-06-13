variable "role_name" {
  description = "GitHub Actions IAM role name."
  type        = string
}

variable "github_org" {
  description = "GitHub organization or user."
  type        = string
}

variable "repository_names" {
  description = "GitHub repositories allowed to assume the role."
  type        = set(string)
}

variable "allowed_refs" {
  description = "Git refs allowed to assume the role, for example refs/heads/main."
  type        = set(string)
  default     = ["refs/heads/main"]
}

variable "create_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set false if it already exists in the AWS account."
  type        = bool
  default     = true
}

variable "policy_arns" {
  description = "IAM policies attached to the role."
  type        = set(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
