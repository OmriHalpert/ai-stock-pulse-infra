data "aws_route53_zone" "this" {
  zone_id = var.route53_zone_id
}

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-external-dns"
  description = "Allow ExternalDNS to manage records in a single hosted zone"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["route53:ChangeResourceRecordSets"]
        Resource = [data.aws_route53_zone.this.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-external-dns"

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
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 600
  cleanup_on_fail  = true
  upgrade_install  = true

  set = [
    {
      name  = "provider.name"
      value = "aws"
    },
    {
      name  = "serviceAccount.name"
      value = var.service_account_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.this.arn
    },
    {
      name  = "domainFilters[0]"
      value = trimsuffix(data.aws_route53_zone.this.name, ".")
    },
    {
      name  = "sources[0]"
      value = "ingress"
    },
    {
      name  = "policy"
      value = "sync"
    },
    {
      name  = "txtOwnerId"
      value = var.cluster_name
    }
  ]

  depends_on = [aws_iam_role_policy_attachment.this]
}