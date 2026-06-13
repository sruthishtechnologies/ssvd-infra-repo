output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint."
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  description = "ECR repository URLs."
  value       = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  description = "GitHub Actions role ARN."
  value       = try(module.github_oidc[0].role_arn, null)
}

output "argocd_namespace" {
  description = "Argo CD namespace."
  value       = try(module.argocd[0].namespace, null)
}
