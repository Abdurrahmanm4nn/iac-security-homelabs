resource "google_container_cluster" "template" {
  name                = var.cluster_name
  location            = var.region
  initial_node_count  = var.node_count
  remove_default_node_pool = var.remove_default_node_pool

  node_config {
    disk_size_gb = var.disk_size
    disk_type = var.disk_type
  }

  network = var.network
  subnetwork = var.subnetwork
}