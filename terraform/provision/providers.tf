provider "google" {
  credentials = base64decode(var.credentials)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

data "google_client_config" "default" {}

data "google_container_cluster" "primary_cluster" {
  name = var.cluster_name
  location = var.zone
}

provider "kubernetes" {
  load_config_file = false
  host             = "https://${data.google_container_cluster.primary_cluster.endpoint}"
  token            = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = "https://${data.google_container_cluster.primary_cluster.endpoint}"
    token            = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.primary_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

provider "github" {
  token = var.github_token
}
