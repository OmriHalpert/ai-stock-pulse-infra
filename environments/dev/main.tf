locals {
  cluster_name    = var.cluster_name
  environment     = var.environment
  certificate_arn = data.aws_acm_certificate.wildcard.arn
}

# -----------------------------------------------------------------------------
# Foundation lookups (owned by the foundation root module)
# -----------------------------------------------------------------------------

data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

data "aws_acm_certificate" "wildcard" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}

data "aws_ecr_repository" "repos" {
  for_each = toset(var.repository_names)
  name     = each.value
}

data "aws_secretsmanager_secret_version" "argocd_github_pat" {
  secret_id = "ai-stock-pulse-argocd-github-pat"
}

# -----------------------------------------------------------------------------
# Ephemeral compute stack
# -----------------------------------------------------------------------------

module "vpc" {
  source = "../../modules/vpc"

  cluster_name         = local.cluster_name
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["eu-west-1a", "eu-west-1b"]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = local.cluster_name
  cluster_version     = "1.32"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = ["t3.medium"]
  # Room for kube-prometheus-stack later; 2 nodes is already tight with Argo + app.
  desired_size        = 3
  min_size            = 2
  max_size            = 3
}

module "rds" {
  source                      = "../../modules/rds"
  environment                 = local.environment
  project_name                = "ai-stock-pulse"
  vpc_id                      = module.vpc.vpc_id
  private_subnet_ids          = module.vpc.private_subnet_ids
  eks_nodes_security_group_id = module.eks.node_security_group_id
}

module "albc" {
  source                 = "../../modules/albc"
  cluster_name           = module.eks.cluster_name
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  vpc_id                 = module.vpc.vpc_id
  role_arn               = module.eks.alb_controller_role_arn
  aws_region             = var.aws_region
  certificate_arn        = local.certificate_arn

  depends_on = [module.eks]
}

data "aws_secretsmanager_secret" "app" {
  name = "ai-stock-pulse-dev-app-secret"
}

module "eso" {
  source = "../../modules/eso"

  cluster_name      = local.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider
  secret_arns = [
    module.rds.db_secret_arn,
    data.aws_secretsmanager_secret.app.arn
  ]

  depends_on = [module.eks, module.albc]
}

module "external_dns" {
  source = "../../modules/external-dns"

  cluster_name      = local.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider
  route53_zone_id   = data.aws_route53_zone.primary.zone_id

  depends_on = [module.eks, module.albc]
}

# After ALBC (Ingress webhook) and ESO (ExternalSecret CRDs) so the first GitOps
# sync does not race empty webhooks/CRDs. Destroy reverses this: apps first, then ALBC.
module "argocd" {
  source      = "../../modules/argocd"
  environment = local.environment

  manifests_repo_url = "https://github.com/OmriHalpert/ai-stock-pulse-manifests.git"
  github_pat         = data.aws_secretsmanager_secret_version.argocd_github_pat.secret_string

  depends_on = [module.eks, module.albc, module.eso, module.external_dns]
}
