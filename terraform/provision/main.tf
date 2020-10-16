locals {
  flux_ns              = "flux"
  flux_git_secret_name = "flux-git-deploy"
  flux_gpg_secret_name = "flux-gpg-signing-key"
}

resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "github_repository" "flux-repo" {
  name = var.github_repo
}

resource "github_user_ssh_key" "flux" {
  title = "Flux deploy key (${var.cluster_name})"
  key   = tls_private_key.flux.public_key_openssh
}

resource "kubernetes_namespace" "flux" {
  metadata {
    name = local.flux_ns
  }
}

resource "kubernetes_secret" "flux-gpg-key" {
  depends_on = [kubernetes_namespace.flux]
  metadata {
    name      = local.flux_gpg_secret_name
    namespace = local.flux_ns
  }
  data = {
    "flux.asc" = base64decode(var.flux_gpg_signing_key_file)
  }
  type = "Opaque"
}

resource "kubernetes_secret" "flux-ssh-key" {
  depends_on = [kubernetes_namespace.flux]
  metadata {
    name      = local.flux_git_secret_name
    namespace = local.flux_ns
  }

  type = "Opaque"

  data = {
    identity = tls_private_key.flux.private_key_pem
  }
}

resource "helm_release" "fluxchart" {
  depends_on = [
    kubernetes_secret.flux-ssh-key,
    kubernetes_secret.flux-gpg-key,
    github_user_ssh_key.flux,
  ]
  name       = "flux"
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = "1.5.0"
  namespace  = local.flux_ns

  set {
    name  = "git.secretName"
    value = local.flux_git_secret_name
  }

  set {
    name  = "git.url"
    value = data.github_repository.flux-repo.ssh_clone_url
  }

  set {
    name  = "git.path"
    value = var.flux_git_path
  }

  set {
    name  = "git.user"
    value = var.flux_git_user
  }

  set {
    name  = "git.email"
    value = var.flux_git_email
  }

  set {
    name  = "git.signingKey"
    value = var.flux_git_signingkey
  }

  set {
    name  = "gpgKeys.secretName"
    value = local.flux_gpg_secret_name
  }

  set {
    name  = "manifestGeneration"
    value = "true"
  }

  set {
    name  = "registry.rps"
    value = "20"
  }

  set {
    name  = "registry.automationInterval"
    value = "3m"
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }
}

resource "helm_release" "helm-operator" {
  depends_on = [
    helm_release.fluxchart,
    kubernetes_secret.flux-ssh-key,
  ]
  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = "1.2.0"
  namespace  = local.flux_ns

  set {
    name  = "git.ssh.secretName"
    value = local.flux_git_secret_name
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }
}

