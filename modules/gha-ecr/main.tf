data "aws_caller_identity" "current" {}

# One OIDC provider per AWS account for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # GitHub's OIDC thumbprint (documented by AWS / GitHub)
  thumbprint_list = [
  "6938fd4d98bab03faadb97b34396831e3780aea1",
  "1c58a3a8518e8759bf075b76b750d4c4fa32e068",
  ]
}

resource "aws_iam_role" "gha" {
  name = "${var.name_prefix}-gha-ecr-push"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_org}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:ref:refs/heads/main",
              "repo:${var.github_org}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:pull_request",
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_push" {
  name        = "${var.name_prefix}-gha-ecr-push"
  description = "GitHub Actions push images to Stock Pulse ECR repos"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories"
        ]
        Resource = var.ecr_repository_arns
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_push" {
  role       = aws_iam_role.gha.name
  policy_arn = aws_iam_policy.ecr_push.arn
}