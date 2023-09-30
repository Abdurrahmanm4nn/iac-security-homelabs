output "cluster_name" {
  value = google_container_cluster.template.name
}

output "cluster_location" {
  value = google_container_cluster.template.location
}

output "cluster_endpoint" {
  value = google_container_cluster.template.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.template.master_auth[0].cluster_ca_certificate
}