provider "google" {
  credentials = base64decode(var.credentials)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
