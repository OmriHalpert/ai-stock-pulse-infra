resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-external-secrets"
  description = "Allow External Secrets Operator to read selected Secrets Manager secrets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secret_arns
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-external-secrets"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
            "${var.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "helm_release" "this" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 600
  cleanup_on_fail  = true

  set = [
    {
      name  = "serviceAccount.name"
      value = var.service_account_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.this.arn
    }
  ]

  depends_on = [aws_iam_role_policy_attachment.this]
}