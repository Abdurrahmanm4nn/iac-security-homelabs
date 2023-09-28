# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = var.version_prefix
}

# Separately Managed Node Pool Template
resource "google_container_node_pool" "node_pool_template" {
  name     = var.cluster_name
  location = var.region
  cluster  = var.cluster_name
  node_count = var.node_count
  version      = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.project
    }
    # preemptible  = true
    machine_type = var.gke_machine_type
    image_type = var.node_image_type
    disk_size_gb = var.disk_size
    disk_type = var.disk_type
    tags         = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}