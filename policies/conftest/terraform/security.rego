package terraform.security

deny[msg] {
  role_attachment := input.resource.aws_iam_role_policy_attachment[_]
  contains(role_attachment.policy_arn, "AdministratorAccess")
  msg := "Do not attach AdministratorAccess in committed Terraform."
}

deny[msg] {
  repo := input.resource.aws_ecr_repository[_]
  repo.image_tag_mutability != "IMMUTABLE"
  msg := sprintf("ECR repositories must use immutable image tags, got %v", [repo.image_tag_mutability])
}
