output "elastic_service" {
  value = kubernetes_service.elasticsearch.metadata.0.name
}

output "elastic_port" {
  value = kubernetes_service.elasticsearch.spec.0.port.0.port
}

output "kibana_service" {
  value = kubernetes_service.kibana.metadata.0.name
}

output "kibana_port" {
  value = kubernetes_service.kibana.spec.0.port.0.port
}

output "host" {
  value = google_compute_address.siem-endpoint.address
}

output "endpoint_name" {
  value = google_compute_address.siem-endpoint.name
}