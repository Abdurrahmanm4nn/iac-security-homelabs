resource "kubernetes_ingress_v1" "nginx-ingress" {
  #wait_for_load_balancer = true
  metadata {
    name = "nginx-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect": "false"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          path_type = "Prefix"
          backend {
            service {
              name = var.service_name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }
}