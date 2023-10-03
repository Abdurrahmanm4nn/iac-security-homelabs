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
    replicas = 1
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

          env {
            name = "discovery.type"
            value = "single-node"
          }

          port {
            name = "elasticsearch"
            container_port = 9200
          }
          
          resources {
            limits  = {
              cpu    = "2048m"
              memory = "4096Mi"
            }

            requests = {
              cpu    = "1024m"
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

          port {
            name = "kibana"
            container_port = 5601
          }

          env {
            name = "ELASTICSEARCH_HOSTS"
            value = kubernetes_service.elasticsearch.metadata[0].name
          }

          resources {
            limits  = {
              cpu    = "2048m"
              memory = "4096Mi"
            }

            requests = {
              cpu    = "1024m"
              memory = "2048Mi"
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
      app = kubernetes_deployment.elasticsearch.metadata[0].labels.app
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
      app = kubernetes_deployment.kibana.metadata[0].labels.app
    }
    port {
      port        = var.kibana_port
      target_port = 5601
    }

    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.siem-endpoint.address
  }
}