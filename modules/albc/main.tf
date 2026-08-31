resource "helm_release" "aws_load_balancer_controller" {
  name            = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-load-balancer-controller"
  namespace       = "kube-system"
  version         = "3.5.0"
  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.role_arn
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      # Avoid mutating every Service, If this webhook is registered before its pods have endpoints, other Helm installs fail.
      name  = "enableServiceMutatorWebhook"
      value = "false"
    }
  ]
}