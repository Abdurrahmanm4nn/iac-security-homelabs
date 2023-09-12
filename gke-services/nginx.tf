#resource "kubernetes_ingress_v1" "dvwa-ingress" {
#  metadata {
#    name = "dvwa-ingress"
#    annotations = {
#      "kubernetes.io/ingress.class" = "nginx"
#      "nginx.ingress.kubernetes.io/ssl-redirect": "false"
#      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
#    }
#  }
#  spec {
#    default_backend {
#      service {
#        name = "dvwa-gke"
#        port {
#          name = "dvwa-entry"
#        }
#      }
#    }
#    rule {
#      host = "rmndvwa.duckdns.org"
#      http {
#        path {
#          path = "/*"
#          path_type = "Prefix"
#          backend {
#            service {
#              name = "dvwa-gke"
#              port {
#                name = "dvwa-entry"
#              }
#            }
#          }
#        }
#      }
#    }
#  }
#}