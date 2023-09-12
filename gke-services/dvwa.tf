resource "kubernetes_deployment" "dvwa" {
  metadata {
    name = "dvwa-gke"
    labels = {
      App = "dvwa-gke"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "dvwa-gke"
      }
    }
    template {
      metadata {
        labels = {
          App = "dvwa-gke"
        }
      }
      spec {
        container {
          image = "vulnerables/web-dvwa"
          name  = "dvwa-gke"

          port {
            name = "dvwa-http"
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.3"
              memory = "256Mi"
            }
            requests = {
              cpu    = "125m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "google_compute_address" "default" {
  name   = var.vpc_network
  region = var.region
  project = var.project
}

resource "kubernetes_service" "dvwa" {
  metadata {
    name   = "dvwa-gke"
    labels = {
      App = "dvwa-gke"
    }
  }
  spec {
    selector = {
      App = "dvwa-gke"
    }
    session_affinity = "ClientIP"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "dvwa-http"
      name = "dvwa-entry"
    }
    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.default.address
  }
}