variable "project" {
  type = string
}

variable "credentials" {
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

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
  default = "1.17.12-gke.1501"
}