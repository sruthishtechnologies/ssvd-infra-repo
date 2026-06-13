locals {
  name_prefix  = "${var.project}-${var.environment}"
  cluster_name = "${local.name_prefix}-eks"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "ssvd-infra-repo"
  }
}

module "network" {
  source = "../../modules/network"

  name_prefix  = local.name_prefix
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
  cluster_name = local.cluster_name
  tags         = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  repository_names = ["ssvd-bhoomi-report"]
  tags             = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name           = local.cluster_name
  cluster_version        = var.cluster_version
  subnet_ids             = module.network.public_subnet_ids
  endpoint_public_access = true
  node_instance_types    = var.node_instance_types
  node_desired_size      = var.node_desired_size
  node_min_size          = var.node_min_size
  node_max_size          = var.node_max_size
  node_disk_size         = 20
  tags                   = local.common_tags
}

module "argocd" {
  count  = var.enable_argocd ? 1 : 0
  source = "../../modules/argocd"

  namespace               = "argocd"
  ops_repo_url            = var.ops_repo_url
  ops_repo_revision       = var.ops_repo_revision
  ops_repo_bootstrap_path = "bootstrap/${var.environment}"
  root_app_name           = "${var.project}-${var.environment}-root"
  server_service_type     = "ClusterIP"

  depends_on = [module.eks]
}

module "github_oidc" {
  count  = var.create_github_actions_role ? 1 : 0
  source = "../../modules/github-oidc"

  role_name            = "${local.name_prefix}-github-actions"
  github_org           = var.github_org
  repository_names     = var.github_repositories
  allowed_refs         = ["refs/heads/main"]
  create_oidc_provider = var.create_github_oidc_provider
  tags                 = local.common_tags
}
