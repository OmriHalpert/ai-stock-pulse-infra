resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 600
  cleanup_on_fail  = true

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }
      extraObjects = [
        {
          apiVersion = "v1"
          kind       = "Secret"
          metadata = {
            name      = "repo-ai-stock-pulse-manifests"
            namespace = "argocd"
            labels = {
              "argocd.argoproj.io/secret-type" = "repository"
            }
          }
          stringData = {
            type     = "git"
            url      = var.manifests_repo_url
            username = "x-access-token"
            password = var.github_pat
          }
        }
      ]
    })
  ]
}

# Application CRD is installed by the argo-cd chart. Putting kind: Application in
# extraObjects on the same release fails first apply (API discovery has no mapping yet).
resource "helm_release" "root_app" {
  name                       = "root-app"
  chart                      = "${path.module}/charts/root-app"
  namespace                  = "argocd"
  wait                       = true
  # Destroy waits on Argo's cascade (Ingress + ALB). 120s is too short for that.
  timeout                    = 600
  cleanup_on_fail            = true
  disable_openapi_validation = true

  values = [
    yamlencode({
      repoURL        = var.manifests_repo_url
      targetRevision = "main"
      path           = "apps"
    })
  ]

  depends_on = [helm_release.argocd]
}
