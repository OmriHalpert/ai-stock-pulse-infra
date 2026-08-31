module "dns" {
  source      = "../modules/dns"
  domain_name = var.domain_name
  environment = var.environment
}

module "ecr" {
  source               = "../modules/ecr"
  environment          = var.environment
  repository_names     = var.repository_names
  image_tag_mutability = "MUTABLE"
  force_delete         = false
}

module "gha_ecr" {
  source = "../modules/gha-ecr"

  name_prefix     = "ai-stock-pulse"
  github_org      = "OmriHalpert"
  github_repo     = "ai-stock-pulse-services"
  github_owner_id = "136606460"
  github_repo_id  = "1339536242"
  ecr_repository_arns = values(module.ecr.repository_arns)
}

# Value is set once outside Terraform (never committed):
# aws secretsmanager put-secret-value \
#   --secret-id ai-stock-pulse-argocd-github-pat \
#   --secret-string 'YOUR_GITHUB_PAT'
resource "aws_secretsmanager_secret" "argocd_github_pat" {
  name        = "ai-stock-pulse-argocd-github-pat"
  description = "GitHub PAT for Argo CD to clone ai-stock-pulse-manifests"
}
