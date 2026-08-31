resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

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
        },
        {
          apiVersion = "argoproj.io/v1alpha1"
          kind       = "Application"
          metadata = {
            name       = "root-app"
            namespace  = "argocd"
            finalizers = ["resources-finalizer.argocd.argoproj.io"]
          }
          spec = {
            project = "default"
            source = {
              repoURL        = var.manifests_repo_url
              targetRevision = "main"
              path           = "apps"
            }
            destination = {
              server    = "https://kubernetes.default.svc"
              namespace = "argocd"
            }
            syncPolicy = {
              automated = {
                prune    = true
                selfHeal = true
              }
            }
          }
        }
      ]
    })
  ]
}