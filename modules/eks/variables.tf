variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version. Set null to let AWS choose the current default."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS control plane and node group."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS API endpoint is public."
  type        = bool
  default     = true
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group."
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

variable "node_disk_size" {
  description = "Node root volume size in GiB."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
  default     = {}
}
