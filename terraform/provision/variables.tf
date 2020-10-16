variable "project" {
  type = string
}

variable "credentials" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type = string
  default = "europe-west1-d"
}

variable "github_token" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "flux_git_path" {
  type = string
}

variable "flux_git_user" {
  type = string
}

variable "flux_git_email" {
  type = string
}

variable "flux_git_signingkey" {
  type = string
}

variable "flux_gpg_signing_key_file" {
  type = string
}
