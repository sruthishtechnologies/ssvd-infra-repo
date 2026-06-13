output "role_arn" {
  description = "GitHub Actions role ARN."
  value       = aws_iam_role.github.arn
}
