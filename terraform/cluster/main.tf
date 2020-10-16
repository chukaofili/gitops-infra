resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.zone
  min_master_version = var.cluster_version

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "pool-one"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 3
  version    = var.cluster_version

  node_config {
    disk_size_gb = 50
    disk_type    = "pd-standard"
    machine_type = "n1-standard-2"
    preemptible = true

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  timeouts {
    create = "40m"
    update = "30m"
  }
}

