# 1. Download official AWS Load Balancer Controller IAM Policy document
data "http" "alb_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

# 2. Register the IAM Policy in AWS
resource "aws_iam_policy" "alb_controller" {
  name        = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  description = "Permissions for AWS Load Balancer Controller to manage ALBs and Target Groups"
  policy      = data.http.alb_controller_policy.response_body
}

# 3. Create IAM Role with OIDC Trust Relationship (IRSA)
resource "aws_iam_role" "alb_controller" {
  name = "${var.cluster_name}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# 4. Attach the Policy to the IRSA Role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}