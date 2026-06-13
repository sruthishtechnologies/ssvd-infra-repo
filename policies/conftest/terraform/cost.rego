package terraform.cost

deny[msg] {
  resource := input.resource.aws_nat_gateway[_]
  msg := sprintf("NAT gateways are disabled for this low-cost demo baseline: %v", [resource])
}

deny[msg] {
  node_group := input.resource.aws_eks_node_group[_]
  desired := node_group.scaling_config[_].desired_size
  desired > 2
  msg := sprintf("EKS node desired_size must be <= 2 for demo cost control, got %v", [desired])
}

deny[msg] {
  node_group := input.resource.aws_eks_node_group[_]
  max_size := node_group.scaling_config[_].max_size
  max_size > 3
  msg := sprintf("EKS node max_size must be <= 3 for demo cost control, got %v", [max_size])
}
