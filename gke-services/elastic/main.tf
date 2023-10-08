resource "google_compute_address" "siem-endpoint" {
  name   = var.address_name
  project = var.project
  region = var.region
  network_tier = var.network_tier
}

resource "kubernetes_deployment" "elasticsearch" {
  metadata {
    name = "elasticsearch"
    labels = {
      app = "elasticsearch"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "elasticsearch"
      }
    }

    template {
      metadata {
        labels = {
          app = "elasticsearch"
        }
      }

      spec {
        container {
          image = "docker.elastic.co/elasticsearch/elasticsearch:7.10.1"
          name  = "elasticsearch"

          port {
            name = "elasticsearch"
            container_port = 9200
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9200
            }
            initial_delay_seconds = 300
            period_seconds = 60
            timeout_seconds = 60
            success_threshold = 1
            failure_threshold = 5
          }

          env {
            name = "discovery.type"
            value = "single-node"
          }
          
          resources {
            limits  = {
              cpu    = "1536m"
              memory = "4096Mi"
            }

            requests = {
              cpu    = "512m"
              memory = "2048Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "kibana" {
  metadata {
    name = "kibana"
    labels = {
      app = "kibana"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kibana"
      }
    }

    template {
      metadata {
        labels = {
          app = "kibana"
        }
      }

      spec {
        container {
          image = "docker.elastic.co/kibana/kibana:7.10.1"
          name  = "kibana"

          readiness_probe {
            http_get {
              path = "/app/home"
              port = 5601
            }
            initial_delay_seconds = 300
            period_seconds = 60
            timeout_seconds = 60
            success_threshold = 1
            failure_threshold = 5
          }

          port {
            name = "kibana"
            container_port = 5601
          }

          env {
            name = "ELASTICSEARCH_HOSTS"
            value = "http://${google_compute_address.siem-endpoint.address}:${var.elastic_port}"
          }

          resources {
            limits  = {
              cpu    = "2048m"
              memory = "8192Mi"
            }

            requests = {
              cpu    = "1024m"
              memory = "4096Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "elasticsearch" {
  metadata {
    name = "elasticsearch"
  }
  spec {
    selector = {
      app = "elasticsearch"
    }
    port {
      port        = var.elastic_port
      target_port = 9200
    }

    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.siem-endpoint.address
  }
}

resource "kubernetes_service" "kibana" {
  metadata {
    name = "kibana"
  }
  spec {
    selector = {
      app = "kibana"
    }
    port {
      port        = var.kibana_port
      target_port = 5601
    }

    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.siem-endpoint.address
  }
}