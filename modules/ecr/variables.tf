variable "repository_names" {
  description = "ECR repositories to create."
  type        = set(string)
}

variable "tags" {
  description = "Tags applied to repositories."
  type        = map(string)
  default     = {}
}
