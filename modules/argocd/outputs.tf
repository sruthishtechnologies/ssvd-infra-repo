output "namespace" {
  description = "Argo CD namespace."
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "root_application_name" {
  description = "Root Argo CD application name."
  value       = var.root_app_name
}
