resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }
      server = {
        service = {
          type = var.server_service_type
        }
      }
      redis-ha = {
        enabled = false
      }
      controller = {
        replicas = 1
      }
      repoServer = {
        replicas = 1
      }
      applicationSet = {
        replicas = 1
      }
    })
  ]
}

resource "helm_release" "root_app" {
  name      = var.root_app_name
  chart     = "${path.module}/root-app"
  namespace = kubernetes_namespace_v1.argocd.metadata[0].name

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  values = [
    yamlencode({
      rootApp = {
        name           = var.root_app_name
        namespace      = var.namespace
        repoURL        = var.ops_repo_url
        targetRevision = var.ops_repo_revision
        path           = var.ops_repo_bootstrap_path
      }
    })
  ]

  depends_on = [helm_release.argocd]
}
